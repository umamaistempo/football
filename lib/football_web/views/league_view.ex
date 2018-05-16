defmodule FootballWeb.LeagueView do
  use FootballWeb, :view
  alias FootballWeb.LeagueView

  def render("index.json", %{leagues: leagues}) do
    %{data: render_many(leagues, LeagueView, "league.json")}
  end

  def render("show.json", %{league: league}) do
    %{data: render_one(league, LeagueView, "league.json")}
  end

  def render("league.json", %{league: league}) do
    %{
      code: league.code,
      name: league.name,
      _links: %{
        self: api_league_url(FootballWeb.Endpoint, :show, league),
        seasons: api_league_season_url(FootballWeb.Endpoint, :index, league)
      }
    }
  end
end
