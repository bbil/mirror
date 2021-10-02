defmodule MirrorProvider.Weather.OpenWeatherClient do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.openweathermap.org/data/2.5/weather"
  plug Tesla.Middleware.JSON

  def get_current_weather() do
    {:ok, env}  = get("", query: [q: "Toronto", units: "metric", appid: api_key()])

    case env do
      %Tesla.Env{status: 200, body: b} -> {:ok, success_response(b)}
      %Tesla.Env{status: s, body: b} -> {:error, error_response(s, b)}
    end
  end

  defp api_key do
    Application.get_env(:mirror, MirrorProviders.OpenWeather)[:api_key]
  end

  defp error_response(status, %{"message" => message}), do: {:error, {status, message}}

  defp success_response(%{"main" => main}) do
    %{
      temperature: Map.get(main, "temp"),
      feels_like: Map.get(main, "feels_like"),
      humidity: Map.get(main, "humidity")
    }
  end
end
