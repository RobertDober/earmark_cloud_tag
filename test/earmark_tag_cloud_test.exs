defmodule EarmarkTagCloudTest do
  use ExUnit.Case
  doctest EarmarkTagCloud

  describe "some simple examples" do
    test "two tags" do
      lines = ["ruby 1 2 3", "elixir 3 4 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">",
        "  <span style=\"color: #525252; font-size: 10pt; font-weight: 100;\">ruby</span>",
        "  <span style=\"color: #ffffff; font-size: 40pt; font-weight: 800;\">elixir</span>",
        "</div>"
      ], []} 

      assert render_lines(lines) == expected
    end
  end


  defp render_lines(lines), do: lines |> prepare_lines() |> EarmarkTagCloud.render()
  defp prepare_lines(lines), do: Enum.zip(lines, (1..Enum.count(lines)))
end
