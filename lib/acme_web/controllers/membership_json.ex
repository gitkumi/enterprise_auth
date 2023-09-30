defmodule AcmeWeb.MembershipJSON do
  alias Acme.Accounts.Membership

  @doc """
  Renders a list of memberships.
  """
  def index(%{memberships: memberships}) do
    %{data: for(membership <- memberships, do: data(membership))}
  end

  @doc """
  Renders a single membership.
  """
  def show(%{membership: membership}) do
    %{data: data(membership)}
  end

  defp data(%Membership{} = membership) do
    %{
      id: membership.id
    }
  end
end
