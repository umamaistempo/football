defmodule Football.Game.League.Season.Match do
  @moduledoc """
  Represents a match between two teams on a season of a certain league.
  """

  use Ecto.Schema

  alias Ecto.Changeset
  alias Football.Game.League.Season

  @type t :: %__MODULE__{}
  @type changeset :: changeset(Changeset.action())
  @type changeset(action) :: %Changeset{data: %__MODULE__{}, action: action}

  schema "matches" do
    field(:league_season_id, :integer)

    field(:game_date, :date)

    field(:half_time_home_goals, :integer)
    field(:half_time_away_goals, :integer)
    field(:full_time_home_goals, :integer)
    field(:full_time_away_goals, :integer)

    belongs_to(
      :season,
      Season,
      foreign_key: :league_season_id,
      references: :id,
      define_field: false
    )
  end

  @spec create(Season.t(), term, term, map) :: changeset(:insert)
  @doc """
  Prepares a changeset to _create_ a new Match.

  ## Parameters
    - `game_date` - the date when the match happens.
    - `half_time_home_goals` - How many goals the home team has scored during
    the first time.
    - `half_time_away_goals` - How many goals the away team has scored during
    the first time.
    - `full_time_home_goals` - How many goals the home team has scored during
    the match.
    - `full_time_away_goals` - How many goals the away team has scored during
    the match.
  """
  def create(season, home_team, away_team, params) do
    %__MODULE__{}
    |> Changeset.cast(params, [:game_date])
    |> Changeset.validate_required([:game_date])
    |> input_results(params)
    |> Changeset.put_assoc(:season, season)
    # |> Changeset.put_assoc(:home_team, home_team)
    # |> Changeset.put_assoc(:away_team, away_team)
    |> Map.put(:action, :insert)
  end

  @spec update(t | changeset, map) :: changeset(:update)
  @doc """
  Prepares a changeset to _update_ `data`.

  ## Parameters
    - `half_time_home_goals` - How many goals the home team has scored during
    the first time.
    - `half_time_away_goals` - How many goals the away team has scored during
    the first time.
    - `full_time_home_goals` - How many goals the home team has scored during
    the match.
    - `full_time_away_goals` - How many goals the away team has scored during
    the match.
  """
  def update(data, params) do
    data
    |> Changeset.change()
    |> input_results(params)
    |> Map.put(:action, :update)
  end

  @spec input_results(changeset, map) :: changeset
  defp input_results(changeset, params) do
    changeset
    |> Changeset.cast(
      params,
      [
        :half_time_home_goals,
        :half_time_away_goals,
        :full_time_home_goals,
        :full_time_away_goals
      ]
    )
    |> Changeset.validate_number(:half_time_home_goals, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:half_time_away_goals, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:half_time_home_goals, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:full_time_home_goals, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:full_time_away_goals, greater_than_or_equal_to: 0)
  end
end
