defmodule Acme.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Acme.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "not secure password"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Acme.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Acme.Accounts.create_team()

    team
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Acme.Accounts.create_role()

    role
  end

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Acme.Accounts.create_permission()

    permission
  end

  @doc """
  Generate a membership.
  """
  def membership_fixture(attrs \\ %{}) do
    {:ok, membership} =
      attrs
      |> Enum.into(%{

      })
      |> Acme.Accounts.create_membership()

    membership
  end

  @doc """
  Generate a membership_role.
  """
  def membership_role_fixture(attrs \\ %{}) do
    {:ok, membership_role} =
      attrs
      |> Enum.into(%{

      })
      |> Acme.Accounts.create_membership_role()

    membership_role
  end

  @doc """
  Generate a role_permission.
  """
  def role_permission_fixture(attrs \\ %{}) do
    {:ok, role_permission} =
      attrs
      |> Enum.into(%{

      })
      |> Acme.Accounts.create_role_permission()

    role_permission
  end
end
