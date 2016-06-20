defmodule Issues.Github do
  require Logger

  @github_url Application.get_env(:issues, :github_url)

  def fetch_issues(user, project) do
    Logger.info("Fetching #{user}/#{project}...")

    issues_url(user, project)
    |> HTTPoison.get()
    |> case do
      {:ok, %{status_code: 200, body: body}} ->
        Logger.info("Successful response")
        data = Poison.Parser.parse!(body)
        {:ok, data}
      {_, %{status_code: status_code, body: body}} ->
        Logger.error("Error #{status_code} returned")
        reason = Poison.Parser.parse!(body)["message"]
        {:error, reason}
    end
  end

  defp issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end
end
