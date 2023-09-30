defmodule AcmeWeb.RolePermissionJSON do
  alias Acme.Accounts.RolePermission

  @doc """
  Renders a list of role_permissions.
  """
  def index(%{role_permissions: role_permissions}) do
    %{data: for(role_permission <- role_permissions, do: data(role_permission))}
  end

  @doc """
  Renders a single role_permission.
  """
  def show(%{role_permission: role_permission}) do
    %{data: data(role_permission)}
  end

  defp data(%RolePermission{} = role_permission) do
    %{
      id: role_permission.id
    }
  end
end
