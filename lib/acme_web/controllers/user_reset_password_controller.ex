defmodule AcmeWeb.UserResetPasswordController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias AcmeWeb.ChangesetJSON

  action_fallback AcmeWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        fn token -> "~p/users/reset_password/#{token}" end
      )
    end

    json(conn, %{
      data: %{message: "If your email is in our system, you will receive instructions to reset your password shortly."}
    })
  end

  def update(conn, %{"user" => user_params}) do
    %{"token" => token} = conn.params

    case Accounts.get_user_by_reset_password_token(token) do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          data: %{
            message: "Invalid token."
          }
        })

      user ->
        case Accounts.reset_user_password(user, user_params) do
          {:ok, _} ->
            json(conn, %{data: %{message: "Password reset successfully."}})

          {:error, changeset} ->
            errors = ChangesetJSON.error(%{changeset: changeset})

            json(conn, %{data: %{errors: errors}})
        end
    end
  end
end
