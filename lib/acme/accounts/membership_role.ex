defmodule Acme.Accounts.MembershipRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "membership_roles" do

    field :membership_id, :binary_id
    field :role_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(membership_role, attrs) do
    membership_role
    |> cast(attrs, [])
    |> validate_required([])
  end
end
