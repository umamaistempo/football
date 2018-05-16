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

  @doc """
  Shows data about an specific league season.
  """
  def show(conn, %{"league" => league_code, "season" => season_code}) do
    season =
      league_code
      |> Game.get_league!()
      |> Game.get_season!(season_code)
      |> Game.load_matches()

    overview = Game.season_overview(season)

    render(conn, "show.json", season: season, overview: overview)
  end
end
