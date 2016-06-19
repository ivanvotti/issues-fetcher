defmodule Issues.Github do
  @github_url Application.get_env(:issues, :github_url)

  def fetch_issues(user, project) do
    issues_url(user, project)
    |> HTTPoison.get()
    |> case do
      {:ok, %{status_code: 200, body: body}} ->
        data = Poison.Parser.parse!(body)
        {:ok, data}
      {_, %{body: body}} ->
        reason = Poison.Parser.parse!(body)["message"]
        {:error, reason}
    end
  end

  defp issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end
end
