defmodule Acme.Repo.Migrations.CreateMembershipRoles do
  use Ecto.Migration

  def change do
    create table(:membership_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :membership_id, references(:memberships, on_delete: :nothing, type: :binary_id)
      add :role_id, references(:roles, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:membership_roles, [:membership_id])
    create index(:membership_roles, [:role_id])
  end
end
