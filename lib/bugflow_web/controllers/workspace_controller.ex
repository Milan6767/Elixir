defmodule BugflowWeb.WorkspaceController do
  use BugflowWeb, :controller

  alias Bugflow.Workspaces
  alias Bugflow.Workspaces.Workspace

  action_fallback BugflowWeb.FallbackController

  def index(conn, _params) do
    workspaces = Workspaces.list_workspaces()
    render(conn, :index, workspaces: workspaces)
  end

  def create(conn, %{"workspace" => workspace_params}) do
    with {:ok, %Workspace{} = workspace} <- Workspaces.create_workspace(workspace_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workspaces/#{workspace}")
      |> render(:show, workspace: workspace)
    end
  end

  def show(conn, %{"id" => id}) do
    workspace = Workspaces.get_workspace!(id)
    render(conn, :show, workspace: workspace)
  end

  def update(conn, %{"id" => id, "workspace" => workspace_params}) do
    workspace = Workspaces.get_workspace!(id)

    with {:ok, %Workspace{} = workspace} <- Workspaces.update_workspace(workspace, workspace_params) do
      render(conn, :show, workspace: workspace)
    end
  end

  def delete(conn, %{"id" => id}) do
    workspace = Workspaces.get_workspace!(id)

    with {:ok, %Workspace{}} <- Workspaces.delete_workspace(workspace) do
      send_resp(conn, :no_content, "")
    end
  end
end
