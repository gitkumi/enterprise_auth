defmodule AcmeWeb.UserConfirmationController do
  use AcmeWeb, :controller

  alias Acme.Accounts

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        fn token -> "~p/users/confirm/#{token}" end
      )
    end

    message =
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."

    json(conn, %{message: message})
  end

  def update(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        json(conn, %{message: "User confirmed successfully."})

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            json(conn, %{error: "User is already confirmed."})

          %{} ->
            conn
            |> put_status(:bad_request)
            |> json(%{
              error: "User confirmation link is invalid or it has expired."
            })
        end
    end
  end
end
