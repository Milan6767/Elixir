defmodule BugflowWeb.WorkspaceJSON do
  alias Bugflow.Workspaces.Workspace

  @doc """
  Renders a list of workspaces.
  """
  def index(%{workspaces: workspaces}) do
    %{data: for(workspace <- workspaces, do: data(workspace))}
  end

  @doc """
  Renders a single workspace.
  """
  def show(%{workspace: workspace}) do
    %{data: data(workspace)}
  end

  defp data(%Workspace{} = workspace) do
    %{
      id: workspace.id,
      name: workspace.name,
      description: workspace.description
    }
  end
end
