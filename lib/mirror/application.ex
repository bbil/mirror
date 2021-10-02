defmodule Mirror.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Mirror.Repo,
      MirrorWeb.Telemetry,
      {Phoenix.PubSub, name: Mirror.PubSub},
      MirrorWeb.Endpoint,

      Mirror.ProviderSupervisor
    ]

    opts = [strategy: :one_for_one, name: Mirror.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MirrorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
