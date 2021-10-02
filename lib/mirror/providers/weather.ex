defmodule Mirror.Providers.Weather do
  use GenServer

  require Logger

  alias MirrorProvider.Weather.OpenWeatherClient

  @update_delay 10_000

  defmodule State do
    @type t() :: %{
      temperature: float(),
      feels_like: float(),
      humidity: integer()
    }

    defstruct temperature: 0.0, feels_like: 0.0, humidity: 0
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  @impl GenServer
  def init(state) do
    schedule_update()
    {:ok, state}
  end

  @impl GenServer
  def handle_info(:update, state) do
    new_state = do_update(state)

    schedule_update()
    {:noreply, new_state}
  end

  defp do_update(current_state) do
    OpenWeatherClient.get_current_weather()
    |> tap(&log_weather_update/1)
    |> case do
      {:ok, weather} -> updated_state(weather)
      {:error, _} -> current_state
    end
  end

  defp updated_state(weather) do
    %State{
      temperature: weather.temperature,
      feels_like: weather.feels_like,
      humidity: weather.humidity
    }
  end

  defp log_weather_update(result),
    do: Logger.info("#{inspect(__MODULE__)}.update:weather:#{inspect(result)}")

  defp schedule_update do
    Process.send_after(self(), :update, @update_delay)
  end
end
