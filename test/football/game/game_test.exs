defmodule Football.GameTest do
  use Football.DataCase

  alias Football.Game

  describe "leagues" do
    alias Football.Game.League

    @valid_attrs %{code: "code", name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{code: nil, name: nil}

    def league_fixture(attrs \\ %{}) do
      {:ok, league} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_league()

      league
    end

    test "list_leagues/0 returns all leagues" do
      league = league_fixture()
      assert Game.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given code" do
      league = league_fixture()
      assert Game.get_league!(league.code) == league
    end

    test "create_league/1 with valid data creates a league" do
      assert {:ok, %League{} = league} = Game.create_league(@valid_attrs)
      assert league.code == "code"
      assert league.name == "some name"
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_league(@invalid_attrs)
    end

    test "update_league/2 with valid data updates the league" do
      league = league_fixture()
      assert {:ok, league} = Game.update_league(league, @update_attrs)
      assert %League{} = league
      assert league.name == "some updated name"
    end

    test "update_league/2 with invalid data returns error changeset" do
      league = league_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_league(league, @invalid_attrs)
      assert league == Game.get_league!(league.code)
    end

    test "delete_league/1 deletes the league" do
      league = league_fixture()
      assert {:ok, %League{}} = Game.delete_league(league)

      assert_raise Ecto.NoResultsError, fn ->
        Game.get_league!(league.code)
      end
    end
  end
end