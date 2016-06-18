defmodule Issues.CLI do
  @default_issues_limit 4

  def main(args) do
    args
    |> parse_args()
    |> inspect()
    |> IO.puts
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
end
