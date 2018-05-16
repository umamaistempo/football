defmodule FootballWeb.MatchView do
  use FootballWeb, :view

  alias FootballWeb.TeamView

  def render("match.json", %{match: match}) do
    %{
      id: match.id,
      game_date: match.game_date,
      half_time_home_goals: match.half_time_home_goals,
      half_time_away_goals: match.half_time_away_goals,
      full_time_home_goals: match.full_time_home_goals,
      full_time_away_goals: match.full_time_away_goals,
      half_time_result: winner(match.half_time_home_goals, match.half_time_away_goals),
      full_time_result: winner(match.full_time_home_goals, match.full_time_away_goals),
      home_team: render_one(match.home_team, TeamView, "team.json"),
      away_team: render_one(match.away_team, TeamView, "team.json"),
      _links: %{}
    }
  end

  defp winner(home, away) do
    if home && away do
      cond do
        home == away ->
          "draw"

        home > away ->
          "home"

        home < away ->
          "away"
      end
    else
      nil
    end
  end
end
