defmodule Acme.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :name, :string

      timestamps()
    end

    create index(:teams, [:owner_id])
  end
end
