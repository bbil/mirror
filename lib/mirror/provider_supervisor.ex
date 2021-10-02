defmodule Mirror.ProviderSupervisor do
  use Supervisor

  @spec start_link([]) :: Supervisor.on_start()
  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl Supervisor
  def init(_args) do
    children = [
      Mirror.Providers.Weather
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
