defmodule Football.Repo.Migration.Bootstrap do
  use Ecto.Migration

  def change do
    create table(:leagues, primary_key: false) do
      add(:code, :string, primary_key: true)
      add(:name, :string, null: false)
    end

    create table(:league_seasons) do
      add(
        :league_code,
        references(
          :leagues,
          type: :string,
          column: :code,
          on_delete: :delete_all,
          on_update: :update_all
        ),
        null: false
      )

      add(:season_code, :string, null: false)
    end

    create(unique_index(:league_seasons, [:league_code, :season_code]))

    create table(:teams) do
      add(:name, :string, null: false)
    end

    create(unique_index(:teams, [:name]))

    create table(:matches) do
      add(:league_season_id, references(:league_seasons, on_delete: :delete_all), null: false)
      add(:home_team_id, references(:teams, on_delete: :delete_all), null: false)
      add(:away_team_id, references(:teams, on_delete: :delete_all), null: false)
      add(:game_date, :date, null: false)
      add(:half_time_result, :string)
      add(:full_time_result, :string)
      add(:half_time_home_goals, :integer)
      add(:half_time_away_goals, :integer)
      add(:full_time_home_goals, :integer)
      add(:full_time_away_goals, :integer)
    end

    create(index(:matches, [:league_season_id]))
  end
end
