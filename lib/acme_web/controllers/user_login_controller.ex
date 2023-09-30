defmodule AcmeWeb.UserLoginController do
  use AcmeWeb, :controller

  alias Acme.{Accounts, Guardian}

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn
      |>json(%{
          user: json_user(user),
          token: token
        })
    else
      conn
      |> put_status(:bad_request)
      |> json(%{
          error: "Invalid email or password."
        })
    end
  end

  defp json_user(user) do
    %{
      id: user.id,
      email: user.email,
      confirmed_at: user.confirmed_at
    }
  end
end
