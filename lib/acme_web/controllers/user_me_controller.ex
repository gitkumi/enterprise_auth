defmodule AcmeWeb.UserMeController do
  use AcmeWeb, :controller

  action_fallback AcmeWeb.FallbackController

  def show(conn, _opts) do
    user = conn.private.guardian_default_resource

    conn
    |> put_view(json: AcmeWeb.UserJSON)
    |> render(:show, user: user)
  end
end
