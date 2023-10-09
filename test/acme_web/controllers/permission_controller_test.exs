defmodule AcmeWeb.PermissionControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Guardian
  alias Acme.Accounts.Permission

  @update_attrs %{
    name: "some updated name"
  }

  @invalid_attrs %{name: nil}

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
    test "lists all permissions", %{conn: conn} do
      conn = get(conn, ~p"/api/permissions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create permission" do
    test "renders permission when data is valid", %{conn: conn} do
      team = team_fixture()

      params = %{
        team_id: team.id,
        name: "some name",
      }

      conn = post(conn, ~p"/api/permissions", permission: params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/permissions/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/permissions", permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update permission" do
    setup [:create_permission]

    test "renders permission when data is valid", %{
      conn: conn,
      permission: %Permission{id: id} = permission
    } do
      conn = put(conn, ~p"/api/permissions/#{permission}", permission: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/permissions/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, permission: permission} do
      conn = put(conn, ~p"/api/permissions/#{permission}", permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete permission" do
    setup [:create_permission]

    test "deletes chosen permission", %{conn: conn, permission: permission} do
      conn = delete(conn, ~p"/api/permissions/#{permission}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/api/permissions/#{permission}")
      end)
    end
  end

  defp create_permission(_) do
    permission = permission_fixture()
    %{permission: permission}
  end
end
