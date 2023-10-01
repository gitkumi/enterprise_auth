defmodule AcmeWeb.UserSettingsControllerTest do
  use AcmeWeb.ConnCase, async: true

  import Acme.AccountsFixtures
  alias Acme.{Guardian}

  setup do
    %{user: user_fixture()}
  end

  test "it should be able to update password", %{conn: conn, user: user} do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    payload = %{
      "action" => "update_password",
      "current_password" => "not secure password",
      "user" => %{
        "password" => "secure password"
      }
    }

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put(~p"/api/users/settings", payload)

    assert json_response(conn, 200) == %{
             "message" =>
               "Password updated successfully."
           }
  end

  test "it should not be able to update on wrong password", %{conn: conn, user: user} do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    payload = %{
      "action" => "update_password",
      "current_password" => "wrong password",
      "user" => %{
        "password" => "secure password"
      }
    }

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put(~p"/api/users/settings", payload)

    assert json_response(conn, 400)
  end

  test "it should not be able to update on changeset error", %{conn: conn, user: user} do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    payload = %{
      "action" => "update_password",
      "current_password" => "not secure password",
      "user" => %{
        "password" => "short"
      }
    }

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put(~p"/api/users/settings", payload)

    assert json_response(conn, 400)
  end

  test "it should be able to update email", %{conn: conn, user: user} do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    payload = %{
      "action" => "update_email",
      "current_password" => "not secure password",
      "user" => %{
        "email" => "newemail@test.com"
      }
    }

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put(~p"/api/users/settings", payload)

    assert json_response(conn, 200) == %{
             "message" =>
               "A link to confirm your email change has been sent to the new address."
           }

    # TODO: Test if the link sent to email works properly.
  end
end
