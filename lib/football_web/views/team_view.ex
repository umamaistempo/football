defmodule FootballWeb.TeamView do
  use FootballWeb, :view

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      _links: %{}
    }
  end

  def render("overview.json", %{team: team}) do
    %{
      team: render_one(team.team, TeamView, "team.json"),
      games: team.games,
      goals: team.goals,
      wins: team.wins,
      losses: team.losses,
      draws: team.draws
    }
  end
end
