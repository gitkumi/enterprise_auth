defmodule AcmeWeb.TeamControllerTest do
  use AcmeWeb.ConnCase

  import Acme.AccountsFixtures

  alias Acme.Guardian
  alias Acme.Accounts.Team

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
    test "lists all teams", %{conn: conn} do
      conn = get(conn, ~p"/api/teams")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn, user: user} do
      params = %{
        name: "some name"
      }

      conn = post(conn, ~p"/api/teams", team: params)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/teams/#{id}")

      owner_id = user.id

      assert %{
               "id" => ^id,
               "owner_id" => ^owner_id,
               "name" => "some name",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/teams", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put(conn, ~p"/api/teams/#{team}", team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/teams/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, ~p"/api/teams/#{team}", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, ~p"/api/teams/#{team}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/teams/#{team}")
      end
    end
  end

  defp create_team(_) do
    team = team_fixture()
    %{team: team}
  end
end
