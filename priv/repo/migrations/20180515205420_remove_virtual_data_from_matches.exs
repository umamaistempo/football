defmodule Football.Repo.Migration.RemoveVirtualDataFromMatches do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      remove(:half_time_result)
      remove(:full_time_result)
    end
  end
end
