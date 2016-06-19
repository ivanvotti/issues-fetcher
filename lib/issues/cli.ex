defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table: 2]

  alias Issues.Github

  @default_issues_limit 4

  def main(args) do
    args
    |> parse_args()
    |> process()
  end

  def parse_args(args) do
    options = OptionParser.parse(
      args,
      strict: [user: :string, project: :string, limit: :integer, help: :boolean],
      aliases: [h: :help, u: :user, p: :project, l: :limit]
    )

    # {parsed_switches, other_args, invalid_args}
    case options do
      {_, _, invalid_args} when length(invalid_args) > 0 ->
        :help
      {[help: true], _, _} ->
        :help
      {[user: user, project: project, limit: limit], _, _} ->
        {user, project, limit}
      {[user: user, project: project], _, _} ->
        {user, project, @default_issues_limit}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts("usage: issues -u <user> -p <project> [ -l <limit> | 4 ]")
    System.halt(0)
  end
  def process({user, project, limit}) do
    Github.fetch_issues(user, project)
    |> decode_response()
    |> sort_issues()
    |> Enum.take(limit)
    |> print_table(
      fields: ["number", "created_at", "title"],
      headers: ["Issue #", "Created at", "Title"]
    )
  end

  defp decode_response(response) do
    case response do
      {:ok, data} -> data
      {:error, reason} ->
        IO.puts("There was an error: #{reason}")
        System.halt(2)
    end
  end

  def sort_issues(issues) do
    Enum.sort(issues, &(&1["created_at"] <= &2["created_at"]))
  end
end
