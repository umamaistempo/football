alias Football.Game
alias Football.Repo

current_year = Date.utc_today().year

parse_date = fn date ->
  [day, month, year] =
    ~r/\//
    |> Regex.split(date)
    |> Enum.map(&String.to_integer/1)

  year =
    if year + 2000 > current_year do
      1900 + year
    else
      2000 + year
    end

  {:ok, date} = Date.new(year, month, day)
  date
end

{leagues, teams, matches} =
  "data.csv"
  |> Path.expand(__DIR__)
  |> File.stream!()
  |> CSV.decode!(strip_fields: true, separator: ?,)
  |> Enum.drop(1)
  |> Enum.reduce({%{}, MapSet.new(), []}, fn row, {leagues, teams, matches} ->
    [
      _,
      league,
      season,
      game_date,
      home_team,
      away_team,
      fthg,
      ftag,
      _,
      hthg,
      htag,
      _
    ] = row

    leagues = Map.update(leagues, league, MapSet.new([season]), &MapSet.put(&1, season))

    teams =
      teams
      |> MapSet.put(home_team)
      |> MapSet.put(away_team)

    match = %{
      season: {league, season},
      game_date: parse_date.(game_date),
      home_team: home_team,
      away_team: away_team,
      full_time_home_goals: fthg,
      full_time_away_goals: ftag,
      half_time_home_goals: hthg,
      half_time_away_goals: htag
    }

    {leagues, teams, [match | matches]}
  end)

Repo.transaction(fn ->
  seasons =
    leagues
    |> Enum.map(fn {league_code, seasons} ->
      {:ok, league} = Game.create_league(%{code: league_code})

      {league, {league_code, seasons}}
    end)
    |> Enum.flat_map(fn {league, {league_code, seasons}} ->
      Enum.map(seasons, fn season_code ->
        {:ok, season} = Game.create_season(league, %{season_code: season_code})

        {{league_code, season_code}, season}
      end)
    end)
    |> Map.new()

  teams =
    Map.new(teams, fn team_name ->
      {:ok, team} = Game.create_team(%{name: team_name})

      {team_name, team}
    end)

  Enum.each(matches, fn match ->
    season = Map.fetch!(seasons, match.season)
    home_team = Map.fetch!(teams, match.home_team)
    away_team = Map.fetch!(teams, match.away_team)

    {:ok, _} = Game.create_match(season, home_team, away_team, match)
  end)
end)
