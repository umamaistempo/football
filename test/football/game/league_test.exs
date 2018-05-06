defmodule Football.Game.LeagueTest do
  use ExUnit.Case, async: true

  alias Football.Game.League

  describe "create/1" do
    test "requires code"
    test "code must have less than four characters"
    test "code can only contain ASCII alphanumerical characters"
    test "name is required"
  end

  describe "update/1" do
    test "allows to change name"
    test "cannot remove name"
    test "does not allow to change code"
  end
end
