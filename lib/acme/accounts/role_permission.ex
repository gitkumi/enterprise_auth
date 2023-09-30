defmodule Acme.Accounts.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "role_permissions" do

    field :role_id, :binary_id
    field :permission_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [])
    |> validate_required([])
  end
end
