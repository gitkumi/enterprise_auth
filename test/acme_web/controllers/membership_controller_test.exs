defmodule AcmeWeb.MembershipControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Guardian
  alias Acme.Accounts.Membership

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
    test "lists all memberships", %{conn: conn} do
      conn = get(conn, ~p"/api/memberships")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create membership" do
    test "renders membership when data is valid", %{conn: conn} do
      user = user_fixture()
      team = team_fixture()

      params = %{
        user_id: user.id,
        team_id: team.id
      }

      conn = post(conn, ~p"/api/memberships", membership: params)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/memberships/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/memberships", membership: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete membership" do
    setup [:create_membership]

    test "deletes chosen membership", %{conn: conn, membership: membership} do
      conn = delete(conn, ~p"/api/memberships/#{membership}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/memberships/#{membership}")
      end
    end
  end

  defp create_membership(_) do
    membership = membership_fixture()
    %{membership: membership}
  end
end
