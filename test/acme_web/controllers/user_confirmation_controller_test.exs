defmodule AcmeWeb.UserConfirmationControllerTest do
  use AcmeWeb.ConnCase, async: true

  import Acme.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "it should send confirmation email", %{conn: conn, user: user} do
    payload = %{
      "user" => %{
        "email" => user.email
      }
    }

    conn = post(conn, ~p"/api/users/confirm", payload)

    assert json_response(conn, 200) == %{
             "message" =>
               "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
           }

    # TODO: Test if the link sent to email works properly.
  end

  test "it should act normal if user does not exist", %{conn: conn} do
    payload = %{
      "user" => %{
        "email" => "does not exist"
      }
    }

    conn = post(conn, ~p"/api/users/confirm", payload)

    assert json_response(conn, 200) == %{
             "message" =>
               "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
           }
  end
end
