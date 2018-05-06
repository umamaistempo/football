defmodule FootballWeb.LeagueController do
  use FootballWeb, :controller

  alias Football.Game
  alias Football.Game.League

  action_fallback(FootballWeb.FallbackController)

  def index(conn, _params) do
    leagues = Game.list_leagues()
    render(conn, "index.json", leagues: leagues)
  end

  def create(conn, %{"league" => league_params}) do
    with {:ok, %League{} = league} <- Game.create_league(league_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", league_path(conn, :show, league))
      |> render("show.json", league: league)
    end
  end

  def show(conn, %{"id" => id}) do
    league = Game.get_league!(id)
    render(conn, "show.json", league: league)
  end

  def update(conn, %{"id" => id, "league" => league_params}) do
    league = Game.get_league!(id)

    with {:ok, %League{} = league} <- Game.update_league(league, league_params) do
      render(conn, "show.json", league: league)
    end
  end

  def delete(conn, %{"id" => id}) do
    league = Game.get_league!(id)

    with {:ok, %League{}} <- Game.delete_league(league) do
      send_resp(conn, :no_content, "")
    end
  end
end
