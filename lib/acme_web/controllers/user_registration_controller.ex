defmodule AcmeWeb.UserRegistrationController do
  use AcmeWeb, :controller

  alias AcmeWeb.ChangesetJSON
  alias Acme.{Accounts, Guardian}

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
        |> json(%{
          user: json_user(user),
          token: token
        })

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})
    
        conn
        |> put_status(:bad_request)
        |> json(errors)
    end
  end

  def json_user(user) do
    %{
      id: user.id,
      email: user.email,
      confirmed_at: user.confirmed_at
    }
  end
end
