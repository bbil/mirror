defmodule Mirror.Repo do
  use Ecto.Repo,
    otp_app: :mirror,
    adapter: Ecto.Adapters.Postgres
end
