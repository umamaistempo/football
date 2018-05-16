defmodule FootballWeb.SeasonView do
  use FootballWeb, :view

  alias FootballWeb.MatchView
  alias FootballWeb.SeasonView
  alias FootballWeb.TeamView

  def render("index.json", %{seasons: seasons}) do
    %{data: render_many(seasons, SeasonView, "season.json")}
  end

  def render("show.json", %{season: season, overview: overview}) do
    season =
      season
      |> render_one(SeasonView, "season.json")
      |> Map.put(:matches, render_many(season.matches, MatchView, "match.json"))
      |> Map.put(:overview, render_many(overview, TeamView, "overview.json"))

    %{data: season}
  end

  def render("season.json", %{season: season}) do
    %{
      code: season.season_code,
      league_code: season.league_code,
      _links: %{
        self:
          api_league_season_path(
            FootballWeb.Endpoint,
            :show,
            season.league_code,
            season.season_code
          )
      }
    }
  end
end
