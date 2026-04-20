defmodule BugflowWeb.IssueController do
  use BugflowWeb, :controller

  alias Bugflow.Issues
  alias Bugflow.Issues.Issue

  action_fallback BugflowWeb.FallbackController

  def index(conn, params) do
  issues = Issues.list_issues(params)
  render(conn, :index, issues: issues)
  end

  def create(conn, %{"issue" => issue_params}) do
    with {:ok, %Issue{} = issue} <- Issues.create_issue(issue_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/issues/#{issue}")
      |> render(:show, issue: issue)
    end
  end

  def show(conn, %{"id" => id}) do
    issue = Issues.get_issue!(id)
    render(conn, :show, issue: issue)
  end

  def update(conn, %{"id" => id, "issue" => issue_params}) do
    issue = Issues.get_issue!(id)

    with {:ok, %Issue{} = issue} <- Issues.update_issue(issue, issue_params) do
      render(conn, :show, issue: issue)
    end
  end

  def delete(conn, %{"id" => id}) do
    issue = Issues.get_issue!(id)

    with {:ok, %Issue{}} <- Issues.delete_issue(issue) do
      send_resp(conn, :no_content, "")
    end
  end
end
