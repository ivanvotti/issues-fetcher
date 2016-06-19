defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO, only: [capture_io: 1]

  alias Issues.TableFormatter, as: TF

  @source_items [
    [c1: "r1 c1", c2: "r1+++c2", c3: "r1 c3", c4: "r1 c4"],
    [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
    [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"]
  ]

  @selected_fields [:c1, :c2, :c4]

  test "maps_to_rows returns correct rows" do
    assert TF.source_items_to_rows(@source_items, @selected_fields) == [
      ["r1 c1", "r1+++c2", "r1 c4"],
      ["r2 c1", "r2 c2", "r2 c4"],
      ["r3 c1", "r3 c2", "r3 c4"]
    ]
  end

  test "column_widths_for returns correct widths" do
    rows = [
      ["+", "+++", "+++"],
      ["++", "++", "++++"],
    ]
    assert TF.column_widths_for(rows) == [2, 3, 4]
  end

  test "row_format_for returns correct format" do
    assert TF.row_format_for([2, 3, 4]) == "~-2s | ~-3s | ~-4s~n"
  end

  test "separator_for works" do
    assert TF.separator_for([2, 3, 4]) == "---+-----+-----"
  end

  test "print_table output is correct" do
    result = capture_io(fn ->
      TF.print_table(@source_items, fields: @selected_fields)
    end)

    assert result == """
    c1    | c2      | c4   
    ------+---------+------
    r1 c1 | r1+++c2 | r1 c4
    r2 c1 | r2 c2   | r2 c4
    r3 c1 | r3 c2   | r3 c4
    """
  end
end
