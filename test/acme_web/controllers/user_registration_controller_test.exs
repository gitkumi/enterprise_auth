defmodule AcmeWeb.UserRegistrationControllerTest do
  use AcmeWeb.ConnCase, async: true

  import Acme.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "it should register user", %{conn: conn} do
    payload = %{
      "user" => %{
        "email" => "new@test.com",
        "password" => "not secure password"
      },
      "confirmation_url" => "localhost:8080/{token}"
    }

    conn = post(conn, ~p"/api/users/register", payload)
    assert json_response(conn, 201)
  end

  test "it should not register user when it exist", %{conn: conn, user: user} do
    payload = %{
      "user" => %{
        "email" => user.email,
        "password" => "not secure password"
      },
      "confirmation_url" => "localhost:8080/{token}"
    }

    conn = post(conn, ~p"/api/users/register", payload)
    assert json_response(conn, 400)
  end
end
