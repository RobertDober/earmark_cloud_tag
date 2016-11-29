defmodule Support.Render do
  def render_lines(lines), do: lines |> prepare_lines() |> EarmarkTagCloud.render()
  def prepare_lines(lines), do: Enum.zip(lines, (1..Enum.count(lines)))
end
