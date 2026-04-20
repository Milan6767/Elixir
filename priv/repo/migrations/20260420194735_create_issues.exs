defmodule Bugflow.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :status, :string
      add :priority, :string

      timestamps(type: :utc_datetime)
    end
  end
end
