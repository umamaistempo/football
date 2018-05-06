defmodule Football.Game.LeagueTest do
  use ExUnit.Case, async: true

  alias Football.Game.League

  import Football.Test.Support.ChangesetHelper

  describe "create/1" do
    test "requires code" do
      changeset = League.create(%{})

      assert :required in failed_validations(changeset).code
    end

    test "code must have less than four characters" do
      changeset = League.create(%{code: "aaaa"})

      refute :length in failed_validations(changeset).code

      changeset = League.create(%{code: "aaaaa"})

      assert :length in failed_validations(changeset).code
    end

    test "code can only contain ASCII alphanumerical characters" do
      changeset = League.create(%{code: "HI99"})

      refute :format in failed_validations(changeset).code

      changeset = League.create(%{code: "José"})

      assert :format in failed_validations(changeset).code
    end

    test "code is downcased" do
      data =
        %{code: "AEo9", name: "Example"}
        |> League.create()
        |> Ecto.Changeset.apply_changes()

      assert data.code == "aeo9"
    end

    test "name is required" do
      changeset = League.create(%{})

      assert :required in failed_validations(changeset).name
    end

    test "changeset is insert-only" do
      changeset = League.create(%{code: "E0", name: "English Premier League"})

      assert changeset.valid?
      assert changeset.action == :insert
    end
  end

  describe "update/1" do
    test "allows to change name" do
      changeset = League.update(%League{name: "foobar"}, %{name: "Lemon"})

      assert changeset.valid?

      data = Ecto.Changeset.apply_changes(changeset)

      assert data.name == "Lemon"
    end

    test "cannot remove name" do
      data = %League{name: "foobar"}

      changeset = League.update(data, %{name: ""})

      refute changeset.valid?
      assert :required in failed_validations(changeset).name
    end

    test "does not allow to change code" do
      data = %League{name: "foobar", code: "foo"}

      changeset = League.update(data, %{code: "bar"})

      assert changeset.valid?
      refute :code in Map.keys(changeset.changes)

      updated = Ecto.Changeset.apply_changes(changeset)
      assert updated.code == "foo"
    end
  end
end
