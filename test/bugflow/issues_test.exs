defmodule Bugflow.IssuesTest do
  use Bugflow.DataCase

  alias Bugflow.Issues

  describe "issues" do
    alias Bugflow.Issues.Issue

    import Bugflow.IssuesFixtures
    import Bugflow.WorkspacesFixtures

    @invalid_attrs %{priority: nil, status: nil, description: nil, title: nil}

    # ------------------------
    # CRUD
    # ------------------------

    test "list_issues/0 returns all issues" do
      issue = issue_fixture()
      assert Issues.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id" do
      issue = issue_fixture()
      assert Issues.get_issue!(issue.id) == issue
    end

    test "create_issue/1 with valid data creates a issue" do
      workspace = workspace_fixture()

      valid_attrs = %{
        priority: "high",
        status: "open",
        description: "User cannot log in",
        title: "Login bug",
        workspace_id: workspace.id
      }

      assert {:ok, %Issue{} = issue} = Issues.create_issue(valid_attrs)
      assert issue.priority == "high"
      assert issue.status == "open"
      assert issue.description == "User cannot log in"
      assert issue.title == "Login bug"
      assert issue.workspace_id == workspace.id
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Issues.create_issue(@invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue" do
      issue = issue_fixture()

      update_attrs = %{
        priority: "medium",
        status: "in_progress",
        description: "Bug is being investigated",
        title: "Login bug investigation"
      }

      assert {:ok, %Issue{} = issue} = Issues.update_issue(issue, update_attrs)
      assert issue.priority == "medium"
      assert issue.status == "in_progress"
      assert issue.description == "Bug is being investigated"
      assert issue.title == "Login bug investigation"
    end

    test "update_issue/2 with invalid data returns error changeset" do
      issue = issue_fixture()
      assert {:error, %Ecto.Changeset{}} = Issues.update_issue(issue, @invalid_attrs)
      assert issue == Issues.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue" do
      issue = issue_fixture()
      assert {:ok, %Issue{}} = Issues.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Issues.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset" do
      issue = issue_fixture()
      assert %Ecto.Changeset{} = Issues.change_issue(issue)
    end

    # ------------------------
    # FILTERS
    # ------------------------

    test "list_issues/1 filters by status" do
      workspace = workspace_fixture()

      issue_open =
        issue_fixture(%{
          workspace_id: workspace.id,
          status: "open",
          title: "Open issue"
        })

      _issue_done =
        issue_fixture(%{
          workspace_id: workspace.id,
          status: "done",
          title: "Done issue"
        })

      result = Issues.list_issues(%{"status" => "open"})

      assert length(result) == 1
      assert hd(result).id == issue_open.id
    end

    test "list_issues/1 filters by priority" do
      workspace = workspace_fixture()

      issue_high =
        issue_fixture(%{
          workspace_id: workspace.id,
          priority: "high",
          title: "High priority issue"
        })

      _issue_low =
        issue_fixture(%{
          workspace_id: workspace.id,
          priority: "low",
          title: "Low priority issue"
        })

      result = Issues.list_issues(%{"priority" => "high"})

      assert length(result) == 1
      assert hd(result).id == issue_high.id
    end

    test "list_issues/1 filters by workspace and status together" do
      workspace_1 = workspace_fixture(%{name: "Workspace 1"})
      workspace_2 = workspace_fixture(%{name: "Workspace 2"})

      issue =
        issue_fixture(%{
          workspace_id: workspace_1.id,
          status: "open",
          title: "Matching issue"
        })

      _other_workspace_issue =
        issue_fixture(%{
          workspace_id: workspace_2.id,
          status: "open",
          title: "Wrong workspace"
        })

      _other_status_issue =
        issue_fixture(%{
          workspace_id: workspace_1.id,
          status: "done",
          title: "Wrong status"
        })

      result =
        Issues.list_issues(%{
          "workspace_id" => workspace_1.id,
          "status" => "open"
        })

      assert length(result) == 1
      assert hd(result).id == issue.id
    end

    # ------------------------
    # SORT
    # ------------------------

    test "list_issues/1 sorts by inserted_at_desc" do
  workspace = workspace_fixture()

  older_issue =
    issue_fixture(%{
      workspace_id: workspace.id,
      title: "Older issue"
    })

  Process.sleep(1100)

  newer_issue =
    issue_fixture(%{
      workspace_id: workspace.id,
      title: "Newer issue"
    })

  result =
    Issues.list_issues(%{
      "workspace_id" => workspace.id,
      "sort" => "inserted_at_desc"
    })

  assert length(result) == 2
  assert Enum.at(result, 0).id == newer_issue.id
  assert Enum.at(result, 1).id == older_issue.id
  end
  end
end
