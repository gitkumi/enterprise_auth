defmodule Acme.Accounts.MembershipRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "membership_roles" do

    belongs_to :membership, Acme.Accounts.Membership, type: :binary_id
    belongs_to :role, Acme.Accounts.Role, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(membership_role, attrs) do
    membership_role
    |> cast(attrs, [:membership_id, :role_id])
    |> validate_required([:membership_id, :role_id])
  end
end
