defmodule FootballWeb.SeasonController do
  @moduledoc false
  use FootballWeb, :controller

  alias Football.Game

  action_fallback(FootballWeb.FallbackController)

  @doc """
  Lists all seasons within a league.
  """
  def index(conn, %{"league" => league_code}) do
    league =
      league_code
      |> Game.get_league!()
      |> Game.load_seasons()

    render(conn, "index.json", seasons: league.seasons)
  end
end
