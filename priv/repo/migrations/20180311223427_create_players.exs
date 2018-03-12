defmodule Checkers.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :game, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:players, [:user_id])
  end
end
