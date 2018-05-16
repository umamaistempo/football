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

  def match_format?(value) do
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
      assert Enum.all?(data, &match_format?/1)
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
          "self" => resource_path
        }
      }

      assert data == expected
    end
  end
end
