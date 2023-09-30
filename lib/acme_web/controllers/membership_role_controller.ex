defmodule AcmeWeb.MembershipRoleController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias Acme.Accounts.MembershipRole

  action_fallback AcmeWeb.FallbackController

  def index(conn, _params) do
    membership_roles = Accounts.list_membership_roles()
    render(conn, :index, membership_roles: membership_roles)
  end

  def create(conn, %{"membership_role" => membership_role_params}) do
    with {:ok, %MembershipRole{} = membership_role} <- Accounts.create_membership_role(membership_role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/membership_roles/#{membership_role}")
      |> render(:show, membership_role: membership_role)
    end
  end

  def show(conn, %{"id" => id}) do
    membership_role = Accounts.get_membership_role!(id)
    render(conn, :show, membership_role: membership_role)
  end

  def update(conn, %{"id" => id, "membership_role" => membership_role_params}) do
    membership_role = Accounts.get_membership_role!(id)

    with {:ok, %MembershipRole{} = membership_role} <- Accounts.update_membership_role(membership_role, membership_role_params) do
      render(conn, :show, membership_role: membership_role)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership_role = Accounts.get_membership_role!(id)

    with {:ok, %MembershipRole{}} <- Accounts.delete_membership_role(membership_role) do
      send_resp(conn, :no_content, "")
    end
  end
end
