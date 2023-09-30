defmodule Acme.Accounts.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "memberships" do

    belongs_to :user, Acme.Accounts.User, type: :binary_id
    belongs_to :team, Acme.Accounts.Team, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
  end
end
