defmodule Football.Game.League.MatchTest do
  use ExUnit.Case, async: true

  alias Football.Game.League
  alias Football.Game.League.Season
  alias Football.Game.League.Season.Match

  import Football.Test.Support.ChangesetHelper

  def season do
    %Season{
      season_code: "201617",
      league_code: "foo",
      league: %League{code: "foo"}
    }
  end

  def team do
    %{}
  end

  describe "create/4" do
    test "requires game_date" do
      changeset = Match.create(season(), team(), team(), %{})

      assert :required in failed_validations(changeset).game_date
    end

    test "only required data is game_date" do
      changeset = Match.create(season(), team(), team(), %{game_date: ~D[2000-01-01]})

      assert changeset.valid?
    end

    test "changeset is insert-only" do
      changeset = Match.create(season(), team(), team(), %{game_date: ~D[2000-01-01]})

      assert changeset.action == :insert
    end

    test "half_time_home_goals can't be negative" do
      changeset = Match.create(season(), team(), team(), %{half_time_home_goals: -1})

      assert :number in failed_validations(changeset).half_time_home_goals

      changeset = Match.create(season(), team(), team(), %{half_time_home_goals: 0})
      refute :number in failed_validations(changeset).half_time_home_goals

      changeset = Match.create(season(), team(), team(), %{half_time_home_goals: 1})
      refute :number in failed_validations(changeset).half_time_home_goals
    end

    test "half_time_away_goals can't be negative" do
      changeset = Match.create(season(), team(), team(), %{half_time_away_goals: -1})

      assert :number in failed_validations(changeset).half_time_away_goals

      changeset = Match.create(season(), team(), team(), %{half_time_away_goals: 0})
      refute :number in failed_validations(changeset).half_time_away_goals

      changeset = Match.create(season(), team(), team(), %{half_time_away_goals: 1})
      refute :number in failed_validations(changeset).half_time_away_goals
    end

    test "full_time_home_goals can't be negative" do
      changeset = Match.create(season(), team(), team(), %{full_time_home_goals: -1})

      assert :number in failed_validations(changeset).full_time_home_goals

      changeset = Match.create(season(), team(), team(), %{full_time_home_goals: 0})
      refute :number in failed_validations(changeset).full_time_home_goals

      changeset = Match.create(season(), team(), team(), %{full_time_home_goals: 1})
      refute :number in failed_validations(changeset).full_time_home_goals
    end

    test "full_time_away_goals can't be negative" do
      changeset = Match.create(season(), team(), team(), %{full_time_away_goals: -1})

      assert :number in failed_validations(changeset).full_time_away_goals

      changeset = Match.create(season(), team(), team(), %{full_time_away_goals: 0})
      refute :number in failed_validations(changeset).full_time_away_goals

      changeset = Match.create(season(), team(), team(), %{full_time_away_goals: 1})
      refute :number in failed_validations(changeset).full_time_away_goals
    end
  end

  describe "update/2" do
    test "half_time_home_goals can't be negative" do
      changeset = Match.update(%Match{}, %{half_time_home_goals: -1})

      assert :number in failed_validations(changeset).half_time_home_goals

      changeset = Match.update(%Match{}, %{half_time_home_goals: 0})
      refute :number in failed_validations(changeset).half_time_home_goals

      changeset = Match.update(%Match{}, %{half_time_home_goals: 1})
      refute :number in failed_validations(changeset).half_time_home_goals
    end

    test "half_time_away_goals can't be negative" do
      changeset = Match.update(%Match{}, %{half_time_away_goals: -1})

      assert :number in failed_validations(changeset).half_time_away_goals

      changeset = Match.update(%Match{}, %{half_time_away_goals: 0})
      refute :number in failed_validations(changeset).half_time_away_goals

      changeset = Match.update(%Match{}, %{half_time_away_goals: 1})
      refute :number in failed_validations(changeset).half_time_away_goals
    end

    test "full_time_home_goals can't be negative" do
      changeset = Match.update(%Match{}, %{full_time_home_goals: -1})

      assert :number in failed_validations(changeset).full_time_home_goals

      changeset = Match.update(%Match{}, %{full_time_home_goals: 0})
      refute :number in failed_validations(changeset).full_time_home_goals

      changeset = Match.update(%Match{}, %{full_time_home_goals: 1})
      refute :number in failed_validations(changeset).full_time_home_goals
    end

    test "full_time_away_goals can't be negative" do
      changeset = Match.update(%Match{}, %{full_time_away_goals: -1})

      assert :number in failed_validations(changeset).full_time_away_goals

      changeset = Match.update(%Match{}, %{full_time_away_goals: 0})
      refute :number in failed_validations(changeset).full_time_away_goals

      changeset = Match.update(%Match{}, %{full_time_away_goals: 1})
      refute :number in failed_validations(changeset).full_time_away_goals
    end
  end
end
