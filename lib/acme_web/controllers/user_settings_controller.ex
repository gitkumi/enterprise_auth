defmodule AcmeWeb.UserSettingsController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias AcmeWeb.ChangesetJSON

  def update(conn, %{"action" => "update_email", "confirmation_url" => confirmation_url} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.private.guardian_default_resource

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          fn token -> String.replace(confirmation_url, "{token}", token) end
        )

        conn
        |> json(%{
          message: "A link to confirm your email change has been sent to the new address."
        })

      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})

        conn
        |> json(errors)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.private.guardian_default_resource

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, _user} ->
        conn
        |> json(%{
          message: "Password updated successfully."
        })

      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})

        conn
        |> put_status(:bad_request)
        |> json(errors)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    user = conn.private.guardian_default_resource

    case Accounts.update_user_email(user, token) do
      :ok ->
        conn
        |> json(%{
          message: "Email changed successfully."
        })

      :error ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          error: "Email change link is invalid or it has expired."
        })
    end
  end
end
