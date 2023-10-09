defmodule AcmeWeb.TeamController do
  use AcmeWeb, :controller

  alias Acme.Accounts
  alias Acme.Accounts.Team

  action_fallback AcmeWeb.FallbackController

  def index(conn, _params) do
    teams = Accounts.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    user = conn.private.guardian_default_resource
    params = Map.put(team_params, "owner_id", user.id)

    with {:ok, %Team{} = team} <- Accounts.create_team(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Accounts.get_team!(id)

    with {:ok, %Team{} = team} <- Accounts.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)

    with {:ok, %Team{}} <- Accounts.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
