defmodule BugflowWeb.IssueJSON do
  alias Bugflow.Issues.Issue

  def index(%{issues: issues}) do
    %{data: for(issue <- issues, do: data(issue))}
  end

  def show(%{issue: issue}) do
    %{data: data(issue)}
  end

  defp data(%Issue{} = issue) do
    %{
      id: issue.id,
      title: issue.title,
      description: issue.description,
      status: issue.status,
      priority: issue.priority,
      workspace_id: issue.workspace_id
    }
  end
end
