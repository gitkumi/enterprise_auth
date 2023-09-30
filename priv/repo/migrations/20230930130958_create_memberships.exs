defmodule Acme.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:memberships, [:user_id])
    create index(:memberships, [:team_id])
  end
end
