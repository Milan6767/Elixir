defmodule Bugflow.Issues.Issue do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "issues" do
    field :title, :string
    field :description, :string
    field :status, :string
    field :priority, :string

    belongs_to :workspace, Bugflow.Workspaces.Workspace

    timestamps(type: :utc_datetime)
  end

  def changeset(issue, attrs) do
    issue
    |> cast(attrs, [:title, :description, :status, :priority, :workspace_id])
    |> validate_required([:title, :status, :priority, :workspace_id])
    |> validate_length(:title, min: 3, max: 120)
    |> validate_inclusion(:status, ["open", "in_progress", "done"])
    |> validate_inclusion(:priority, ["low", "medium", "high"])
  end
end
