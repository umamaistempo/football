defmodule Football.Game.League do
  @moduledoc """
  Represents a game league.

  A league is a group of sports teams that compete against each other.

  Each league has an unique universal code (`t:code/0`) that identifies it
  through the public API.
  """

  use Ecto.Schema

  alias Ecto.Changeset
  alias Football.Game.League.Season

  @type code :: String.t()
  @type t :: %__MODULE__{
          code: code(),
          name: String.t(),
          seasons: [Season.t()] | term
        }
  @type changeset :: changeset(Changeset.action())
  @type changeset(action) :: %Changeset{data: %__MODULE__{}, action: action}

  @derive {Phoenix.Param, key: :code}

  @primary_key false
  schema "leagues" do
    field(:code, :string, primary_key: true)
    field(:name, :string)

    has_many(:seasons, Season, foreign_key: :league_code, references: :code)
  end

  @spec create(map) :: changeset(:insert)
  @doc """
  Prepares a changeset to _create_ a new League.

  ## Parameters
    - `code` - The unique code for the league (used on the public API for
    search).
    - `name` - The full name of the League.
  """
  def create(params) do
    %__MODULE__{}
    |> Changeset.cast(params, [:code, :name])
    |> Changeset.validate_required([:name])
    |> validate_code()
    |> Map.put(:action, :insert)
  end

  @spec update(t | changeset, map) :: changeset(:update)
  @doc """
  Prepares a changeset to _update_ `data`.

  ## Parameters
    - `name` - The full name of the League.
  """
  def update(data, params) do
    data
    |> Changeset.cast(params, [:name])
    |> Changeset.validate_required([:name])
    |> Map.put(:action, :update)
  end

  @spec validate_code(changeset) :: changeset
  defp validate_code(changeset) do
    changeset
    |> Changeset.validate_required([:code])
    |> Changeset.validate_length(:code, max: 4)
    |> Changeset.validate_format(:code, ~r/^[a-zA-Z0-9]+$/)
    |> Changeset.update_change(:code, &String.downcase/1)
    |> Changeset.unique_constraint(:code)
  end
end
