defmodule Issues.TableFormatter do
  def print_table(source_items, fields: fields) do
    headers = Enum.map(fields, &printable/1)
    print_table(source_items, fields: fields, headers: headers)
  end
  def print_table(source_items, fields: fields, headers: headers) do
    rows = source_items_to_rows(source_items, fields)
    column_widths = column_widths_for(rows ++ [headers])
    row_format = row_format_for(column_widths)

    print_row(headers, row_format)
    IO.puts(separator_for(column_widths))
    Enum.each(rows, &(print_row(&1, row_format)))
  end

  def source_items_to_rows(source_items, fields) do
    for map <- source_items do
      for field <- fields, do: printable(map[field])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def column_widths_for(rows) do
    columns =
      rows
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)

    for column <- columns do
      column
      |> Enum.map(&String.length/1)
      |> Enum.max()
    end
  end

  @doc """
  Return a format string that hard codes the widths of a set of columns.
  We put `" | "` between each column.

  ## Example
    iex> import Issues.TableFormatter
    iex> column_widths = [2, 3, 4]
    iex> row_format_for(column_widths)
    "~-2s | ~-3s | ~-4s~n"
  """
  def row_format_for(column_widths) do
    Enum.map_join(column_widths, " | ", fn(width) -> "~-#{width}s" end) <> "~n"
  end

  def print_row(row, format) do
    :io.format(format, row)
  end

  @doc """
  Generate the line that goes below the column headings.
  It is a string of hyphens, with + signs where the vertical bar
  between the columns goes.

  ## Example
    iex> import Issues.TableFormatter
    iex> column_widths = [2, 3, 4]
    iex> separator_for(column_widths)
    "---+-----+-----"
  """
  def separator_for(column_widths) do
    Enum.map_join(column_widths, "-+-", &List.duplicate("-", &1))
  end
end
