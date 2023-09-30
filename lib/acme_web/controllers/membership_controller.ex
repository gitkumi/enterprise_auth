defmodule AcmeWeb.MembershipController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias Acme.Accounts.Membership

  action_fallback AcmeWeb.FallbackController

  def index(conn, _params) do
    memberships = Accounts.list_memberships()
    render(conn, :index, memberships: memberships)
  end

  def create(conn, %{"membership" => membership_params}) do
    with {:ok, %Membership{} = membership} <- Accounts.create_membership(membership_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/memberships/#{membership}")
      |> render(:show, membership: membership)
    end
  end

  def show(conn, %{"id" => id}) do
    membership = Accounts.get_membership!(id)
    render(conn, :show, membership: membership)
  end

  def delete(conn, %{"id" => id}) do
    membership = Accounts.get_membership!(id)

    with {:ok, %Membership{}} <- Accounts.delete_membership(membership) do
      send_resp(conn, :no_content, "")
    end
  end
end
