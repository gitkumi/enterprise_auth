defmodule Acme.Accounts.Permission do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "permissions" do
    field :name, :string
    belongs_to :team, Acme.Accounts.Team, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :team_id])
    |> validate_required([:name, :team_id])
  end
end
