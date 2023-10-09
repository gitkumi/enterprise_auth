defmodule AcmeWeb.MembershipRoleControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Guardian
  alias Acme.Accounts.MembershipRole

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all membership_roles", %{conn: conn} do
      conn = get(conn, ~p"/api/membership_roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create membership_role" do
    test "renders membership_role when data is valid", %{conn: conn} do
      membership = membership_fixture()
      role = role_fixture()

      params = %{
        membership_id: membership.id,
        role_id: role.id,
      }

      conn = post(conn, ~p"/api/membership_roles", membership_role: params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/membership_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/membership_roles", membership_role: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete membership_role" do
    setup [:create_membership_role]

    test "deletes chosen membership_role", %{conn: conn, membership_role: membership_role} do
      conn = delete(conn, ~p"/api/membership_roles/#{membership_role}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/membership_roles/#{membership_role}")
      end
    end
  end

  defp create_membership_role(_) do
    membership_role = membership_role_fixture()
    %{membership_role: membership_role}
  end
end
