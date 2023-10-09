defmodule AcmeWeb.UserJSON do
  alias Acme.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user with token.
  """
  def show(%{user: user, token: token}) do
    %{data: %{user: data(user), token: token}}
  end

  def show(%{user: user}) do
    %{data: %{user: data(user)}}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      confirmed_at: user.confirmed_at,
      first_name: user.first_name,
      last_name: user.last_name
    }
  end
end
