defmodule AcmeWeb.RolePermissionControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Accounts.RolePermission

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all role_permissions", %{conn: conn} do
      conn = get(conn, ~p"/api/role_permissions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create role_permission" do
    test "renders role_permission when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/role_permissions", role_permission: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/role_permissions/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/role_permissions", role_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update role_permission" do
    setup [:create_role_permission]

    test "renders role_permission when data is valid", %{conn: conn, role_permission: %RolePermission{id: id} = role_permission} do
      conn = put(conn, ~p"/api/role_permissions/#{role_permission}", role_permission: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/role_permissions/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, role_permission: role_permission} do
      conn = put(conn, ~p"/api/role_permissions/#{role_permission}", role_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete role_permission" do
    setup [:create_role_permission]

    test "deletes chosen role_permission", %{conn: conn, role_permission: role_permission} do
      conn = delete(conn, ~p"/api/role_permissions/#{role_permission}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/role_permissions/#{role_permission}")
      end
    end
  end

  defp create_role_permission(_) do
    role_permission = role_permission_fixture()
    %{role_permission: role_permission}
  end
end
