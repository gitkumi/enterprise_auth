defmodule AcmeWeb.UserMeController do
  use AcmeWeb, :controller

  def show(conn, _opts) do
    user = conn.private.guardian_default_resource

    conn
    |> json(%{
      user: %{
        id: user.id,
        email: user.email,
        confirmed_at: user.confirmed_at
      }
    })
  end
end
