defmodule Football.Game.League do
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @type changeset :: changeset(Ecto.Changeset.action())
  @type changeset(action) :: %Ecto.Changeset{data: %__MODULE__{}, action: action}

  @primary_key false
  schema "leagues" do
    add(:code, :string, primary_key: true)
    add(:name, :string)
  end

  @type create(map) :: changeset(:insert)
  def create(params) do
    %__MODULE__{}
    |> cast(params, [:code, :name])
    |> validate_required([:code, :name])
    |> validate_format(:code, ~r/^[a-zA-Z0-9]$/)
    |> update_change(:code, &String.downcase/1)
    |> unique_constraint(:code)
    |> Map.put(:action, :insert)
  end
end
