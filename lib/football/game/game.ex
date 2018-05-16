defmodule Football.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false

  alias Football.Game.League
  alias Football.Game.League.Season
  alias Football.Game.League.Season.Match
  alias Football.Game.Team
  alias Football.Repo

  @spec list_leagues() :: [League.t()]
  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    Repo.all(League)
  end

  @spec get_league!(League.code()) :: League.t() | no_return
  @doc """
  Gets a single league.

  Raises `Ecto.NoResultsError` if the League does not exist.

  ## Examples

      iex> get_league!("foo")
      %League{}

      iex> get_league!("bar")
      ** (Ecto.NoResultsError)

  """
  def get_league!(code), do: Repo.get_by!(League, code: String.downcase(code))

  @spec get_season!(League.t(), Season.code()) :: Season.t() | no_return
  @doc """
  Gets a single season that belongs to `league`.

  Raises `Ecto.NoResultsError` if the Season does not exist.

  ## Examples

      iex> get_season!(%League{}, "foo")
      %League{}

      iex> get_season!(%League{}, "bar")
      ** (Ecto.NoResultsError)
  """
  def get_season!(league = %League{}, season_code) do
    league
    |> Ecto.assoc(:seasons)
    |> where([s], s.season_code == ^season_code)
    |> Repo.one!()
  end

  @spec load_seasons(League.t()) :: League.t()
  @doc """
  Loads seasons from `league` into it.
  """
  def load_seasons(league), do: Repo.preload(league, :seasons)

  @spec create_league(map) :: {:ok, League.t()} | {:error, League.changeset()}
  @doc """
  Creates a league.

  ## Examples

      iex> create_league(%{field: value})
      {:ok, %League{}}

      iex> create_league(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_league(attrs) do
    attrs
    |> League.create()
    |> Repo.insert()
  end

  @spec update_league(League.t(), map) :: {:ok, League.t()} | {:error, League.changeset()}
  @doc """
  Updates a league.

  ## Examples

      iex> update_league(league, %{field: new_value})
      {:ok, %League{}}

      iex> update_league(league, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_league(%League{} = league, attrs) do
    league
    |> League.update(attrs)
    |> Repo.update()
  end

  @spec create_season(League.t(), map) :: {:ok, Season.t()} | {:error, Season.changeset()}
  @doc """
  Starts a new season on `league`.

  ## Examples

      iex> create_season(league, %{season_code: "201617"})
      {:ok, %Season{}}
  """
  def create_season(league, attrs) do
    league
    |> Season.create(attrs)
    |> Repo.insert()
  end

  @spec season_overview(Season.t()) :: Season.Overview.t()
  @doc """
  Produces an overview of teams data based on the season match results.
  """
  def season_overview(season) do
    Season.Overview.overview(season)
  end

  @spec create_team(map) :: {:ok, Team.t()} | {:error, Team.changeset()}
  @doc """
  Creates a new team.

  ## Examples

      iex> create_team(%{name: "Team Team"})
      {:ok, %Team{}}
  """
  def create_team(attrs) do
    attrs
    |> Team.create()
    |> Repo.insert()
  end

  @spec create_match(Season.t(), Team.t(), Team.t(), map) ::
          {:ok, Match.t()} | {:error, Match.changeset()}
  @doc """
  Creates a match between `home_team` and `away_team` during `season`.

  ## Examples

      iex> create_match(
      ...>   %Season{},
      ...>   %Team{},
      ...>   %Team{},
      ...>   %{game_date: ~D[2000-01-01]}
      ...> )
      {:ok, %Match{}}
  """
  def create_match(season, home_team, away_team, attrs) do
    season
    |> Match.create(home_team, away_team, attrs)
    |> Repo.insert()
  end

  @spec load_matches(Season.t()) :: Season.t()
  @doc """
  Loads matches from `season` into it.
  """
  def load_matches(season), do: Repo.preload(season, matches: [:home_team, :away_team])
end
