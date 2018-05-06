defmodule Football.Game.League do
  @moduledoc """
  Represents a game league.

  A league is a group of sports teams that compete against each other.

  Each league has an unique universal code (`t:code/0`) that identifies it
  through the public API.
  """

  use Ecto.Schema

  @type code :: String.t()
  @type t :: %__MODULE__{
          code: code(),
          name: String.t()
        }
  @type changeset :: changeset(Ecto.Changeset.action())
  @type changeset(action) :: %Ecto.Changeset{data: %__MODULE__{}, action: action}

  @primary_key false
  schema "leagues" do
    add(:code, :string, primary_key: true)
    add(:name, :string)
  end

  @type create(map) :: changeset(:insert)
  @doc """
  Prepares a changeset to _create_ a new League.

  ## Parameters
    - `code` - The unique code for the league (used on the public API for
    search).
    - `name` - The full name of the League.
  """
  def create(params) do
    %__MODULE__{}
    |> cast(params, [:code, :name])
    |> validate_required([:code, :name])
    |> validate_format(:code, ~r/^[a-zA-Z0-9]$/)
    |> update_change(:code, &String.downcase/1)
    |> unique_constraint(:code)
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
    |> cast(params, :name)
    |> validate_required([:name])
    |> Map.put(:action, :update)
  end
end
