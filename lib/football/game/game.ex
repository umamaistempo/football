defmodule Football.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias Football.Repo

  alias Football.Game.League

  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    Repo.all(League)
  end

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

  @doc """
  Loads seasons from `league`.
  """
  def load_seasons(league), do: Repo.preload(league, :seasons)

  @doc """
  Creates a league.

  ## Examples

      iex> create_league(%{field: value})
      {:ok, %League{}}

      iex> create_league(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_league(attrs \\ %{}) do
    attrs
    |> League.create()
    |> Repo.insert()
  end

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

  @doc """
  Starts a new season on `league`.

  ## Examples

      iex> new_season(league, %{season_code: "201617"})
      {:ok, %Season{}}
  """
  def new_season(league, attrs) do
    league
    |> League.Season.create(attrs)
    |> Repo.insert()
  end
end
