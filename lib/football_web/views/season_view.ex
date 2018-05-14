defmodule FootballWeb.SeasonView do
  use FootballWeb, :view
  alias FootballWeb.SeasonView

  def render("index.json", %{seasons: seasons}) do
    %{data: render_many(seasons, SeasonView, "season.json")}
  end

  def render("show.json", %{season: season}) do
    %{data: render_one(season, SeasonView, "season.json")}
  end

  def render("season.json", %{season: season}) do
    %{
      code: season.season_code,
      league_code: season.league_code,
      _links: %{
        self: api_league_season_path(FootballWeb.Endpoint, :index, season.league_code)
      }
    }
  end
end
