defmodule FootballWeb.SeasonControllerTest do
  use FootballWeb.ConnCase

  alias Football.Game

  @characters Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)

  def insert_league() do
    code =
      @characters
      |> Enum.take_random(4)
      |> to_string()

    {:ok, league} = Game.create_league(%{code: code, name: "foo"})
    league
  end

  def insert_season(league) do
    code =
      @characters
      |> Enum.take_random(4)
      |> to_string

    {:ok, season} = Game.create_season(league, %{season_code: code})
    season
  end

  def random_team_name() do
    @characters
    |> Enum.take_random(8)
    |> to_string()
  end

  def insert_team(name \\ random_team_name()) do
    {:ok, team} = Game.create_team(%{name: name})

    team
  end

  def match_index_format?(value) do
    match?(
      %{
        "code" => _,
        "league_code" => _,
        "_links" => %{
          "self" => _
        }
      },
      value
    )
  end

  def match_show_format?(value) do
    match?(
      %{
        "code" => _,
        "league_code" => _,
        "matches" => _,
        "overview" => _,
        "_links" => %{
          "self" => _
        }
      },
      value
    )
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all seasons within a league", %{conn: conn} do
      league = insert_league()
      insert_season(league)
      insert_season(league)
      insert_season(league)

      conn = get(conn, api_league_season_path(conn, :index, league))
      assert json_response(conn, 200)

      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 3
      assert Enum.all?(data, &match_index_format?/1)
      assert Enum.all?(data, &(&1["league_code"] == league.code))
    end
  end

  describe "show" do
    test "shows an specific season", %{conn: conn} do
      league = insert_league()
      insert_season(league)
      insert_season(league)
      season = insert_season(league)

      resource_path = api_league_season_path(conn, :show, league.code, season.season_code)

      conn = get(conn, resource_path)
      assert json_response(conn, 200)

      data = json_response(conn, 200)["data"]

      expected = %{
        "code" => season.season_code,
        "league_code" => league.code,
        "matches" => [],
        "overview" => [],
        "_links" => %{
          "self" =>
            api_league_season_url(FootballWeb.Endpoint, :show, league.code, season.season_code)
        }
      }

      assert data == expected
    end

    test "includes data about matches", %{conn: conn} do
      league = insert_league()
      season = insert_season(league)
      home = insert_team("foo")
      away = insert_team("bar")

      match_params = %{
        game_date: ~D[2000-01-01],
        half_time_home_goals: 1,
        half_time_away_goals: 0,
        full_time_home_goals: 1,
        full_time_away_goals: 4
      }

      {:ok, match} = Game.create_match(season, home, away, match_params)

      resource_path = api_league_season_path(conn, :show, league.code, season.season_code)
      conn = get(conn, resource_path)
      data = json_response(conn, 200)["data"]

      assert match_show_format?(data)

      assert [data] = data["matches"]

      assert data["id"] == match.id
      assert data["game_date"] == "2000-01-01"

      assert data["half_time_home_goals"] == 1
      assert data["half_time_away_goals"] == 0
      assert data["full_time_home_goals"] == 1
      assert data["full_time_away_goals"] == 4

      assert data["half_time_result"] == "home"
      assert data["full_time_result"] == "away"

      assert data["home_team"]["id"] == home.id
      assert data["home_team"]["name"] == "foo"
      assert data["away_team"]["id"] == away.id
      assert data["away_team"]["name"] == "bar"
    end

    test "includes data about all matches within a season", %{conn: conn} do
      league = insert_league()
      season1 = insert_season(league)
      season2 = insert_season(league)

      new_match = fn season ->
        {:ok, _} =
          Game.create_match(season, insert_team(), insert_team(), %{game_date: ~D[2001-05-06]})
      end

      new_match.(season1)
      new_match.(season1)
      new_match.(season1)
      new_match.(season2)
      new_match.(season2)

      resource_path = api_league_season_path(conn, :show, league.code, season1.season_code)
      conn = get(conn, resource_path)
      data = json_response(conn, 200)["data"]

      assert match_show_format?(data)

      assert [_, _, _] = data["matches"]
    end

    test "includes an overview on team performances", %{conn: conn} do
      league = insert_league()
      season = insert_season(league)
      home = insert_team("foo")
      away = insert_team("bar")
      away2 = insert_team("baz")

      match_params = %{
        game_date: ~D[2000-01-01],
        half_time_home_goals: 1,
        half_time_away_goals: 0,
        full_time_home_goals: 1,
        full_time_away_goals: 4
      }

      {:ok, _} = Game.create_match(season, home, away, match_params)

      match_params = %{
        game_date: ~D[2000-01-01],
        half_time_home_goals: 1,
        half_time_away_goals: 1,
        full_time_home_goals: 1,
        full_time_away_goals: 1
      }

      {:ok, _} = Game.create_match(season, home, away2, match_params)

      resource_path = api_league_season_path(conn, :show, league.code, season.season_code)
      conn = get(conn, resource_path)
      data = json_response(conn, 200)["data"]

      # Note: Ordered by team ID which is linear
      expected = [
        %{
          "team" => %{
            "name" => "foo",
            "id" => home.id,
            "_links" => %{}
          },
          "games" => 2,
          "goals" => 2,
          "wins" => 0,
          "losses" => 1,
          "draws" => 1
        },
        %{
          "team" => %{
            "name" => "bar",
            "id" => away.id,
            "_links" => %{}
          },
          "games" => 1,
          "goals" => 4,
          "wins" => 1,
          "losses" => 0,
          "draws" => 0
        },
        %{
          "team" => %{
            "name" => "baz",
            "id" => away2.id,
            "_links" => %{}
          },
          "games" => 1,
          "goals" => 1,
          "wins" => 0,
          "losses" => 0,
          "draws" => 1
        }
      ]

      assert data["overview"] == expected
    end
  end
end
