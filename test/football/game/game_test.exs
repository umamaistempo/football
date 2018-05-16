defmodule Football.GameTest do
  use Football.DataCase

  alias Football.Game
  alias Football.Game.League
  alias Football.Game.League.Season
  alias Football.Game.League.Season.Match
  alias Football.Game.Team

  @characters Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)

  @league_valid_attrs %{code: "code", name: "some name"}
  @league_update_attrs %{name: "some updated name"}
  @league_invalid_attrs %{code: nil, name: nil}

  def league_fixture(attrs \\ %{}) do
    code =
      @characters
      |> Enum.take_random(4)
      |> to_string()

    {:ok, league} =
      @league_valid_attrs
      |> Map.put(:code, code)
      |> Map.merge(attrs)
      |> Game.create_league()

    league
  end

  def season_fixture(league \\ league_fixture()) do
    code =
      @characters
      |> Enum.take_random(8)
      |> to_string()

    {:ok, season} = Game.create_season(league, %{season_code: code})

    season
  end

  def team_fixture() do
    name =
      @characters
      |> Enum.take_random(8)
      |> to_string()

    {:ok, team} = Game.create_team(%{name: name})

    team
  end

  describe "leagues" do
    test "list_leagues/0 returns all leagues" do
      league = league_fixture()
      assert Game.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given code" do
      league = league_fixture()
      assert Game.get_league!(league.code) == league
    end

    test "create_league/1 with valid data creates a league" do
      assert {:ok, %League{} = league} = Game.create_league(@league_valid_attrs)
      assert league.code == "code"
      assert league.name == "some name"
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_league(@league_invalid_attrs)
    end

    test "update_league/2 with valid data updates the league" do
      league = league_fixture()
      assert {:ok, league} = Game.update_league(league, @league_update_attrs)
      assert %League{} = league
      assert league.name == "some updated name"
    end

    test "update_league/2 with invalid data returns error changeset" do
      league = league_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_league(league, @league_invalid_attrs)
      assert league == Game.get_league!(league.code)
    end

    test "load_seasons/1 will load into the league all seasons it has" do
      league = league_fixture()
      season_fixture(league)
      season_fixture(league)

      assert %Ecto.Association.NotLoaded{} = league.seasons

      league = Game.load_seasons(league)

      assert [%Season{}, %Season{}] = league.seasons
    end
  end

  describe "seasons" do
    test "create_season/2 with valid data creates a new season" do
      league = league_fixture()
      season_params = %{season_code: "201617"}

      assert {:ok, season} = Game.create_season(league, season_params)
      assert %Season{} = season
      assert season.season_code == "201617"
      assert season.league_code == league.code
    end

    test "create_season/2 with invalid data returns error changeset" do
      league = league_fixture()
      season_params = %{season_code: nil}

      assert {:error, %Ecto.Changeset{}} = Game.create_season(league, season_params)
    end

    test "get_season!/2 returns the season with the specified code from league" do
      league0 = league_fixture()
      league1 = league_fixture()
      season = season_fixture(league0)

      assert %Season{} = Game.get_season!(league0, season.season_code)

      assert_raise Ecto.NoResultsError, fn ->
        Game.get_season!(league1, season.season_code)
      end
    end

    test "load_matches/1 will load into the season all matches it has" do
      season = season_fixture()

      {:ok, _} =
        Game.create_match(season, team_fixture(), team_fixture(), %{game_date: ~D[2000-01-01]})

      {:ok, _} =
        Game.create_match(season, team_fixture(), team_fixture(), %{game_date: ~D[2000-01-02]})

      assert %Ecto.Association.NotLoaded{} = season.matches

      season = Game.load_matches(season)

      assert [%Match{}, %Match{}] = season.matches
    end
  end

  describe "matches" do
    test "create_match/4 creates a match for a season" do
      season = season_fixture()

      home = team_fixture()
      away = team_fixture()

      assert {:ok, %Match{}} = Game.create_match(season, home, away, %{game_date: ~D[2000-01-01]})
    end

    test "create_match/4 returns error changeset on invalid input" do
      season = season_fixture()

      home = team_fixture()
      away = team_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Game.create_match(season, home, away, %{game_date: "oh no"})
    end
  end

  describe "teams" do
    test "create_team/1 with valid input creates a team" do
      assert {:ok, %Team{}} = Game.create_team(%{name: "Yes"})
    end

    test "create_team/1 with invalid input returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_team(%{name: 42})
    end
  end
end
