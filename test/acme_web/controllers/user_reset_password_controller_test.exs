defmodule AcmeWeb.UserResetPasswordControllerTest do
  use AcmeWeb.ConnCase, async: true

  import Acme.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "it should send a reset password email", %{conn: conn, user: user} do
    payload = %{
      "user" => %{
        "email" => user.email
      }
    }

    conn = post(conn, ~p"/api/users/reset_password", payload)
    assert json_response(conn, 200)

    # TODO: Test if the link sent to email works properly.
  end

  test "it should act normal if user does not exist", %{conn: conn} do
    payload = %{
      "user" => %{
        "email" => "empty@test.com"
      }
    }

    conn = post(conn, ~p"/api/users/reset_password", payload)
    assert json_response(conn, 200)
  end
end
