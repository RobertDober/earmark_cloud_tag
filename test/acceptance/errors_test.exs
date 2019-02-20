defmodule Acceptance.ErrorsTest do
  use ExUnit.Case
  import Support.Render

  describe "errors and custom settings" do
    test "one complex example should be enough" do
      lines = [
        "set font-family Helvetica U Name It",
        "set scales 10",
        "set div-id hello-world",
        "elixir is king 12 100 3",
        "\\set scales 20",
        "\\set 14 200 48",
        "set scales 50",
        "ruby wont cut it 20 800 51"
      ]
      expected = 
      {[ "<div id=\"hello-world\" class=\"earmark-tag-cloud\" style=\"font-family: Helvetica U Name It;\">\n",
        "  <span style=\"color: #f8f8f8; font-size: 12pt; font-weight: 100;\">elixir is king</span>\n",
        "  <span style=\"color: #3b3b3b; font-size: 14pt; font-weight: 200;\">set</span>\n",
        "</div>\n"
      ], [
        {:error, 89, "missing one or more of necessary integer values (font-size font-weight gray-scale|color) at end of tag specifcation\n--> \\set scales 20"},
        {:error, 92, "value for gray-scale out of legal range. Actual: 51, Allowed: 0..50\n--> ruby wont cut it 20 800 51"}
      ]} 

      assert render_lines(lines, 85) == expected
    end

  end
end
