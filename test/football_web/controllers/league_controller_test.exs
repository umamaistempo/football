defmodule FootballWeb.LeagueControllerTest do
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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all leagues", %{conn: conn} do
      insert_league()
      insert_league()
      insert_league()

      conn = get(conn, league_path(conn, :index))
      assert json_response(conn, 200)

      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 3
      assert Enum.all?(data, &Map.has_key?(&1, "code"))
      assert Enum.all?(data, &Map.has_key?(&1, "name"))
    end
  end

  describe "show" do
    test "show an specific league", %{conn: conn} do
      league = insert_league()

      conn = get(conn, league_path(conn, :show, league.code))
      assert json_response(conn, 200)

      data = json_response(conn, 200)["data"]
      expected = %{"code" => league.code, "name" => league.name}

      assert data == expected
    end
  end
end
