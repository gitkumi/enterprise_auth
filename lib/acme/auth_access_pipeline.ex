defmodule Acme.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :acme

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
