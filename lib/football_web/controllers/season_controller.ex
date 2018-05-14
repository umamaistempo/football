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

  def show(conn, %{"league" => league_code, "season" => season_code}) do
    season =
      league_code
      |> Game.get_league!()
      |> Game.get_season!(season_code)

    render(conn, "show.json", season: season)
  end
end
