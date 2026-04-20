defmodule Bugflow.Repo.Migrations.AddWorkspaceToIssues do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :workspace_id, references(:workspaces, type: :binary_id, on_delete: :delete_all), null: false
    end

    create index(:issues, [:workspace_id])
  end
end
