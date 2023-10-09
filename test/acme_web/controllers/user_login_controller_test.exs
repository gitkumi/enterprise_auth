defmodule AcmeWeb.UserLoginControllerTest do
  use AcmeWeb.ConnCase, async: true

  import Acme.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "it should login user", %{conn: conn, user: user} do
    payload = %{
      "user" => %{
        "email" => user.email,
        "password" => "not secure password"
      }
    }

    conn = post(conn, ~p"/api/users/log_in", payload)
    response = json_response(conn, 200)

    assert %{"data" => %{"user" => user_data, "token" => token}} = response
    assert user_data["email"] == user.email
    assert is_binary(token)
  end

  test "it should not login if password is wrong", %{conn: conn, user: user} do
    payload = %{
      "user" => %{
        "email" => user.email,
        "password" => "wrong password"
      }
    }

    conn = post(conn, ~p"/api/users/log_in", payload)
    assert json_response(conn, 400)
  end

  test "it should act normal if user does not exist", %{conn: conn} do
    payload = %{
      "user" => %{
        "email" => "nothing@test.com",
        "password" => "wrong password"
      }
    }

    conn = post(conn, ~p"/api/users/log_in", payload)
    assert json_response(conn, 400)
  end
end
