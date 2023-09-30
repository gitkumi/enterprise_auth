defmodule AcmeWeb.MembershipRoleJSON do
  alias Acme.Accounts.MembershipRole

  @doc """
  Renders a list of membership_roles.
  """
  def index(%{membership_roles: membership_roles}) do
    %{data: for(membership_role <- membership_roles, do: data(membership_role))}
  end

  @doc """
  Renders a single membership_role.
  """
  def show(%{membership_role: membership_role}) do
    %{data: data(membership_role)}
  end

  defp data(%MembershipRole{} = membership_role) do
    %{
      id: membership_role.id
    }
  end
end
