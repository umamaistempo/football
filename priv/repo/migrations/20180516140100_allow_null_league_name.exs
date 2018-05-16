defmodule Football.Repo.Migration.AllowNullLeagueName do
  use Ecto.Migration

  def change do
    alter table(:leagues) do
      modify(:name, :string, null: true)
    end
  end
end
