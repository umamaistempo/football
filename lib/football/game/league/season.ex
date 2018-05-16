defmodule Football.Game.League.Season do
  @moduledoc """
  Represents a season of a league.
  """

  use Ecto.Schema

  alias Ecto.Changeset
  alias Football.Game.League

  @type id :: pos_integer
  @type code :: String.t()
  @type t :: %__MODULE__{
          id: id,
          season_code: code,
          league_code: League.code(),
          league: League.t() | term
        }
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

  @spec create(League.t(), map) :: changeset(:insert)
  @doc """
  Prepares a changeset to _create_ a new Season.

  ## Params
    - `season_code` - the unique (by league) code to identify this season. Eg:
    `season_code: "201617"`.
  """
  def create(league, params) do
    %__MODULE__{}
    |> Changeset.cast(params, [:season_code])
    |> validate_code()
    |> Changeset.put_assoc(:league, league)
    |> Map.put(:action, :insert)
  end

  @spec validate_code(changeset) :: changeset
  defp validate_code(changeset) do
    changeset
    |> Changeset.validate_required([:season_code])
    |> Changeset.validate_length(:season_code, max: 8)
    |> Changeset.validate_format(:season_code, ~r/^[a-zA-Z0-9]+$/)
    |> Changeset.update_change(:season_code, &String.downcase/1)
    |> Changeset.unique_constraint(:season_code)
  end
end
