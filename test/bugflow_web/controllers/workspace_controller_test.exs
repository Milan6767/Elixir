defmodule BugflowWeb.WorkspaceControllerTest do
  use BugflowWeb.ConnCase

  import Bugflow.WorkspacesFixtures
  alias Bugflow.Workspaces.Workspace

  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description"
  }
  @invalid_attrs %{name: nil, description: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workspaces", %{conn: conn} do
      conn = get(conn, ~p"/api/workspaces")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workspace" do
    test "renders workspace when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workspaces", workspace: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workspaces/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workspaces", workspace: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workspace" do
    setup [:create_workspace]

    test "renders workspace when data is valid", %{conn: conn, workspace: %Workspace{id: id} = workspace} do
      conn = put(conn, ~p"/api/workspaces/#{workspace}", workspace: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workspaces/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workspace: workspace} do
      conn = put(conn, ~p"/api/workspaces/#{workspace}", workspace: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workspace" do
    setup [:create_workspace]

    test "deletes chosen workspace", %{conn: conn, workspace: workspace} do
      conn = delete(conn, ~p"/api/workspaces/#{workspace}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workspaces/#{workspace}")
      end
    end
  end

  defp create_workspace(_) do
    workspace = workspace_fixture()

    %{workspace: workspace}
  end
end
