defmodule Acme.Repo.Migrations.CreateRolePermissions do
  use Ecto.Migration

  def change do
    create table(:role_permissions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role_id, references(:roles, on_delete: :nothing, type: :binary_id)
      add :permission_id, references(:permissions, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:role_permissions, [:role_id])
    create index(:role_permissions, [:permission_id])
  end
end
