defmodule Football.Game.TeamTest do
  use ExUnit.Case, async: true

  alias Football.Game.Team

  import Football.Test.Support.ChangesetHelper

  describe "create/1" do
    test "requires name" do
      changeset = Team.create(%{})

      assert :required in failed_validations(changeset).name
    end

    test "changeset is insert-only" do
      changeset = Team.create(%{name: "Team Maya"})

      assert changeset.valid?
      assert changeset.action == :insert
    end
  end
end
