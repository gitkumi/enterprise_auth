defmodule AcmeWeb.RolePermissionController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias Acme.Accounts.RolePermission

  action_fallback AcmeWeb.FallbackController

  def index(conn, _params) do
    role_permissions = Accounts.list_role_permissions()
    render(conn, :index, role_permissions: role_permissions)
  end

  def create(conn, %{"role_permission" => role_permission_params}) do
    with {:ok, %RolePermission{} = role_permission} <- Accounts.create_role_permission(role_permission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/role_permissions/#{role_permission}")
      |> render(:show, role_permission: role_permission)
    end
  end

  def show(conn, %{"id" => id}) do
    role_permission = Accounts.get_role_permission!(id)
    render(conn, :show, role_permission: role_permission)
  end

  def update(conn, %{"id" => id, "role_permission" => role_permission_params}) do
    role_permission = Accounts.get_role_permission!(id)

    with {:ok, %RolePermission{} = role_permission} <- Accounts.update_role_permission(role_permission, role_permission_params) do
      render(conn, :show, role_permission: role_permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    role_permission = Accounts.get_role_permission!(id)

    with {:ok, %RolePermission{}} <- Accounts.delete_role_permission(role_permission) do
      send_resp(conn, :no_content, "")
    end
  end
end
