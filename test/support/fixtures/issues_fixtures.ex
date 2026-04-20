defmodule Bugflow.IssuesFixtures do
  alias Bugflow.WorkspacesFixtures

  def issue_fixture(attrs \\ %{}) do
    workspace = WorkspacesFixtures.workspace_fixture()

    {:ok, issue} =
      attrs
      |> Enum.into(%{
        title: "Login bug",
        description: "User cannot log in",
        status: "open",
        priority: "high",
        workspace_id: workspace.id
      })
      |> Bugflow.Issues.create_issue()

    issue
  end
end
