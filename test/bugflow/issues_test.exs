defmodule Bugflow.IssuesTest do
  use Bugflow.DataCase

  alias Bugflow.Issues

  describe "issues" do
    alias Bugflow.Issues.Issue

    import Bugflow.IssuesFixtures
    import Bugflow.WorkspacesFixtures

    @invalid_attrs %{priority: nil, status: nil, description: nil, title: nil}

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
  end
end
