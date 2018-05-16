defmodule Football.Game.League.SeasonTest do
  use ExUnit.Case, async: true

  alias Football.Game.League
  alias Football.Game.League.Season

  import Football.Test.Support.ChangesetHelper

  def league do
    %League{code: "foo"}
  end

  describe "create/2" do
    test "requires season_code" do
      changeset = Season.create(league(), %{})

      assert :required in failed_validations(changeset).season_code
    end

    test "season_code must have up to eight characters" do
      changeset = Season.create(league(), %{season_code: "aaaaaaaa"})

      refute :length in failed_validations(changeset).season_code

      changeset = Season.create(league(), %{season_code: "aaaaaaaaa"})

      assert :length in failed_validations(changeset).season_code
    end

    test "code can only contain ASCII alphanumerical characters" do
      changeset = Season.create(league(), %{season_code: "HI99"})

      refute :format in failed_validations(changeset).season_code

      changeset = Season.create(league(), %{season_code: "José"})

      assert :format in failed_validations(changeset).season_code
    end

    test "code is downcased" do
      data =
        league()
        |> Season.create(%{season_code: "AEo9X0mN"})
        |> Ecto.Changeset.apply_changes()

      assert data.season_code == "aeo9x0mn"
    end

    test "changeset is insert-only" do
      changeset = Season.create(league(), %{season_code: "201617"})

      assert changeset.valid?
      assert changeset.action == :insert
    end
  end
end
