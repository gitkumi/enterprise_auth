defmodule AcmeWeb.UserSettingsController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias AcmeWeb.ChangesetJSON

  action_fallback AcmeWeb.FallbackController

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.private.guardian_default_resource

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          fn token -> "~p/users/settings/confirm_email/#{token}" end
        )

        json(conn, %{data: %{message: "A link to confirm your email change has been sent to the new address."}})

      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})

        json(conn, %{data: %{errors: errors}})
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.private.guardian_default_resource

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, _user} ->
        json(conn, %{data: %{message: "Password updated successfully."}})

      {:error, changeset} ->
        errors = ChangesetJSON.error(%{changeset: changeset})

        conn
        |> put_status(:bad_request)
        |> json(%{data: errors})
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    user = conn.private.guardian_default_resource

    case Accounts.update_user_email(user, token) do
      :ok ->
        json(conn, %{data: %{message: "Email changed successfully."}})

      :error ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          data: %{
            error: "Email change link is invalid or it has expired."
          }
        })
    end
  end
end
