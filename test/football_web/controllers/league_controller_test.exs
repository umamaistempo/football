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

  def match_format?(value) do
    match?(
      %{
        "code" => _,
        "name" => _,
        "_links" => %{
          "self" => _,
          "seasons" => _
        }
      },
      value
    )
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all leagues", %{conn: conn} do
      insert_league()
      insert_league()
      insert_league()

      conn = get(conn, api_league_path(conn, :index))
      assert json_response(conn, 200)

      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 3
      assert Enum.all?(data, &match_format?/1)
    end
  end

  describe "show" do
    test "shows an specific league", %{conn: conn} do
      league = insert_league()

      resource_path = api_league_path(conn, :show, league.code)

      conn = get(conn, resource_path)
      assert json_response(conn, 200)

      data = json_response(conn, 200)["data"]

      expected = %{
        "code" => league.code,
        "name" => league.name,
        "_links" => %{
          "self" => resource_path,
          "seasons" => api_league_season_path(conn, :index, league.code)
        }
      }

      assert data == expected
    end
  end
end
