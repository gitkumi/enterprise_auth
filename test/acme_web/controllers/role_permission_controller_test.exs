defmodule AcmeWeb.RolePermissionControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Guardian
  alias Acme.Accounts.RolePermission

  @invalid_attrs %{}

  setup %{conn: conn} do
    user = user_fixture()
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all role_permissions", %{conn: conn} do
      conn = get(conn, ~p"/api/role_permissions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create role_permission" do
    test "renders role_permission when data is valid", %{conn: conn} do
      role = role_fixture()
      permission = permission_fixture()

      params = %{
        role_id: role.id,
        permission_id: permission.id,
      }

      conn = post(conn, ~p"/api/role_permissions", role_permission: params)
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
