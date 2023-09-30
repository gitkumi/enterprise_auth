defmodule Acme.Accounts.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "role_permissions" do

    belongs_to :role, Acme.Accounts.Role, type: :binary_id
    belongs_to :permission, Acme.Accounts.Permission, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id])
    |> validate_required([:role_id, :permission_id])
  end
end
