defmodule AcmeWeb.UserRegistrationController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias Acme.Guardian
  alias AcmeWeb.ChangesetJSON

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        Accounts.deliver_user_confirmation_instructions(
          user,
          fn token -> "~p/users/confirm/#{token}" end
        )

        conn
        |> put_status(:created)
        |> put_view(json: AcmeWeb.UserJSON)
        |> render(:show, user: user, token: token)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})

        conn
        |> put_status(:bad_request)
        |> json(%{data: errors})
    end
  end
end
