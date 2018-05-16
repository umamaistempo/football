defmodule Football.Game.Team do
  @moduledoc """
  Represents a football team.
  """

  use Ecto.Schema

  alias Ecto.Changeset

  @type id :: pos_integer
  @type t :: %__MODULE__{
          id: id,
          name: String.t()
        }
  @type changeset :: changeset(Changeset.action())
  @type changeset(action) :: %Changeset{data: %__MODULE__{}, action: action}

  schema "leagues" do
    field(:name, :string)
  end

  @spec create(map) :: changeset(:insert)
  @doc """
  Prepares a changeset to _create_ a new Team.

  ## Parameters
    - `name` - The full name of the Team.
  """
  def create(params) do
    %__MODULE__{}
    |> Changeset.cast(params, [:name])
    |> Changeset.validate_required([:name])
    |> Map.put(:action, :insert)
  end
end
