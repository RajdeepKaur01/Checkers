defmodule Checkers.Repo.Migrations.CreateAudiences do
  use Ecto.Migration

  def change do
    create table(:audiences) do
      add :game, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:audiences, [:user_id])
  end
end
