defmodule ParseArgsTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

  @default_limit 4
  @valid_args ["--user", "max", "--project", "app"]

  test "returns user, project and default limit if -u/--user and -p/--project are given" do
    assert parse_args(@valid_args) == {"max", "app", @default_limit}
    assert parse_args(["-u", "max", "-p", "app"]) == {"max", "app", @default_limit}
  end

  test "returns custom limit if -l/--limit option is given" do
    assert parse_args(@valid_args ++ ["--limit", "10"]) == {"max", "app", 10}
    assert parse_args(@valid_args ++ ["-l", "10"]) == {"max", "app", 10}

  end

  test "returns :help if no options are given" do
    assert parse_args([]) == :help
  end

  test "returns :help if there are any invalid options" do
    assert parse_args(@valid_args -- ["max"]) == :help
    assert parse_args(@valid_args -- ["app"]) == :help
    assert parse_args(@valid_args ++ ["--limit", "wrong"]) == :help
    assert parse_args(@valid_args ++ ["--invalid"]) == :help
  end

  test "returns :help if -u/--user or -p/--project option is not given" do
    assert parse_args(@valid_args -- ["--user", "max"]) == :help
    assert parse_args(@valid_args -- ["--project", "app"]) == :help
  end

  test "returns :help if -h/--help option is given" do
    assert parse_args(["-h"]) == :help
    assert parse_args(@valid_args ++ ["-h"]) == :help
    assert parse_args(@valid_args ++ ["--help"]) == :help
  end
end
