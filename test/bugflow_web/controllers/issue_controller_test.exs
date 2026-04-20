defmodule BugflowWeb.IssueControllerTest do
  use BugflowWeb.ConnCase

  import Bugflow.IssuesFixtures
  import Bugflow.WorkspacesFixtures
  alias Bugflow.Issues.Issue

  @update_attrs %{
    priority: "medium",
    status: "in_progress",
    description: "Bug is being investigated",
    title: "Login bug investigation"
  }

  @invalid_attrs %{priority: nil, status: nil, description: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all issues", %{conn: conn} do
      conn = get(conn, ~p"/api/issues")
      assert json_response(conn, 200)["data"] == []
    end

    test "lists only issues for a given workspace", %{conn: conn} do
      workspace_1 = workspace_fixture(%{name: "Workspace 1"})
      workspace_2 = workspace_fixture(%{name: "Workspace 2"})

      issue_1 =
        issue_fixture(%{
          workspace_id: workspace_1.id,
          title: "Issue in workspace 1"
        })

      _issue_2 =
        issue_fixture(%{
          workspace_id: workspace_2.id,
          title: "Issue in workspace 2"
        })

      conn = get(conn, ~p"/api/issues?workspace_id=#{workspace_1.id}")
      data = json_response(conn, 200)["data"]

      assert length(data) == 1
      assert hd(data)["id"] == issue_1.id
      assert hd(data)["title"] == "Issue in workspace 1"
    end
  end

  describe "create issue" do
    test "renders issue when data is valid", %{conn: conn} do
      workspace = workspace_fixture()

      create_attrs = %{
        priority: "high",
        status: "open",
        description: "User cannot log in",
        title: "Login bug",
        workspace_id: workspace.id
      }

      conn = post(conn, ~p"/api/issues", issue: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/issues/#{id}")

      assert %{
               "id" => ^id,
               "description" => "User cannot log in",
               "priority" => "high",
               "status" => "open",
               "title" => "Login bug",
               "workspace_id" => workspace_id
             } = json_response(conn, 200)["data"]

      assert workspace_id == workspace.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/issues", issue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update issue" do
    setup [:create_issue]

    test "renders issue when data is valid", %{conn: conn, issue: %Issue{id: id} = issue} do
      conn = put(conn, ~p"/api/issues/#{issue}", issue: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/issues/#{id}")

      assert %{
               "id" => ^id,
               "description" => "Bug is being investigated",
               "priority" => "medium",
               "status" => "in_progress",
               "title" => "Login bug investigation"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, issue: issue} do
      conn = put(conn, ~p"/api/issues/#{issue}", issue: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete issue" do
    setup [:create_issue]

    test "deletes chosen issue", %{conn: conn, issue: issue} do
      conn = delete(conn, ~p"/api/issues/#{issue}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/issues/#{issue}")
      end
    end
  end

  defp create_issue(_) do
    issue = issue_fixture()
    %{issue: issue}
  end
end
