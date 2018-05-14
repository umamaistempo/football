defmodule Football.Game.League.Season do
  @moduledoc """
  Represents a season of a league.
  """

  use Ecto.Schema

  alias Ecto.Changeset
  alias Football.Game.League

  @type code :: String.t()
  @type t :: %__MODULE__{}
  @type changeset :: changeset(Changeset.action())
  @type changeset(action) :: %Changeset{data: %__MODULE__{}, action: action}

  schema "league_seasons" do
    field(:season_code, :string)
    field(:league_code, :string)

    belongs_to(
      :league,
      League,
      define_field: false,
      foreign_key: :league_code,
      references: :code,
      type: :string
    )
  end

  @spec changeset(t | changeset, map) :: changeset
  @doc """
  Prepares a `t:changeset/0` from `data`.

  ## Parameters
    - `season_code` - the unique (by league) code to identify this season. Eg:
    `season_code: "201617"`
  """
  def changeset(data, params) do
    data
    |> Changeset.cast(params, [:season_code])
    |> Changeset.validate_required([:season_code])
  end

  @spec create(League.t(), map) :: changeset(:insert)
  @doc """
  Prepares a changeset to _create_ a new Season.

  ## Params
    - `season_code` - the unique (by league) code to identify this season. Eg:
    `season_code: "201617"`
  """
  def create(league, params) do
    %__MODULE__{}
    |> changeset(params)
    |> Changeset.put_assoc(:league, league)
    |> Map.put(:action, :insert)
  end
end
