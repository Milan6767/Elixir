defmodule Bugflow.Repo do
  use Ecto.Repo,
    otp_app: :bugflow,
    adapter: Ecto.Adapters.Postgres
end
