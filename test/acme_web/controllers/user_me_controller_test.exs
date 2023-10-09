defmodule AcmeWeb.UserMeControllerTest do
  use AcmeWeb.ConnCase, async: true

  import Acme.AccountsFixtures
  alias Acme.{Guardian}

  setup do
    %{user: user_fixture()}
  end

  test "unauthenticated", %{conn: conn} do
    conn = get(conn, ~p"/api/users/me")
    assert json_response(conn, 401) == %{"message" => "unauthenticated"}
  end

  test "should decode user from token", %{conn: conn, user: user} do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> get("/api/users/me")

    assert json_response(conn, 200) == %{
             "data" => %{
               "id" => user.id,
               "email" => user.email,
               "confirmed_at" => user.confirmed_at,
               "first_name" => user.first_name,
               "last_name" => user.last_name
             }
           }
  end
end
