defmodule FootballWeb.LeagueController do
  @moduledoc false
  use FootballWeb, :controller

  alias Football.Game

  action_fallback(FootballWeb.FallbackController)

  @doc """
  Lists all leagues.
  """
  def index(conn, _params) do
    leagues = Game.list_leagues()
    render(conn, "index.json", leagues: leagues)
  end

  @doc """
  Shows data about an specific league.
  """
  def show(conn, %{"code" => code}) do
    league = Game.get_league!(code)
    render(conn, "show.json", league: league)
  end
end
