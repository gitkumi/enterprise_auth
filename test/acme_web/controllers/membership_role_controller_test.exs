defmodule AcmeWeb.MembershipRoleControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Accounts.MembershipRole

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all membership_roles", %{conn: conn} do
      conn = get(conn, ~p"/api/membership_roles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create membership_role" do
    test "renders membership_role when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/membership_roles", membership_role: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/membership_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/membership_roles", membership_role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update membership_role" do
    setup [:create_membership_role]

    test "renders membership_role when data is valid", %{conn: conn, membership_role: %MembershipRole{id: id} = membership_role} do
      conn = put(conn, ~p"/api/membership_roles/#{membership_role}", membership_role: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/membership_roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, membership_role: membership_role} do
      conn = put(conn, ~p"/api/membership_roles/#{membership_role}", membership_role: @invalid_attrs)
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
