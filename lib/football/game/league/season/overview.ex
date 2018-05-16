defmodule Football.Game.League.Season.Overview do
  alias Football.Game.League.Season
  alias Football.Game.Team

  @type overview :: [team_overview]
  @type team_overview :: %{
          team: Team.t(),
          goals: non_neg_integer,
          games: pos_integer,
          wins: non_neg_integer,
          losses: non_neg_integer,
          draws: non_neg_integer
        }

  @spec overview(Season.t()) :: overview
  def overview(season) do
    season.matches
    |> Enum.reduce(%{}, fn el, acc ->
      winner = winner(el.full_time_home_goals, el.full_time_away_goals)

      home = %{
        goals: el.full_time_home_goals,
        games: 1,
        wins: (winner == :home && 1) || 0,
        losses: (winner == :away && 1) || 0,
        draws: (winner == :draw && 1) || 0
      }

      away = %{
        goals: el.full_time_away_goals,
        games: 1,
        wins: (winner == :away && 1) || 0,
        losses: (winner == :home && 1) || 0,
        draws: (winner == :draw && 1) || 0
      }

      acc
      |> Map.update(el.home_team_id, Map.put(home, :team, el.home_team), &sum(&1, home))
      |> Map.update(el.away_team_id, Map.put(away, :team, el.away_team), &sum(&1, away))
    end)
    |> Map.values()
  end

  @spec winner(non_neg_integer, non_neg_integer) :: :home | :away | :draw | nil
  defp winner(home, away) do
    if home && away do
      cond do
        home == away ->
          :draw

        home > away ->
          :home

        home < away ->
          :away
      end
    else
      nil
    end
  end

  @spec sum(map, map) :: map
  defp sum(x, y) do
    Map.merge(x, y, fn _, v1, v2 -> v1 + v2 end)
  end
end
