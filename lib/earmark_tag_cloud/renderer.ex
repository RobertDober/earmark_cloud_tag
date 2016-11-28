defmodule EarmarkTagCloud.Renderer do
  
  def render(parsed_lines) do 
    with context_lines <- parsed_lines |> make_context() do
    end
  end

  def make_context(parsed_lines) do
    with {lines, settings} <- parsed_lines |> Enum.map_reduce(%{}, &context_line/2) do
    end
  end

  defp context_line({:set, key, value}, settings) do
    {nil, Map.put(settings, key, value)}
  end 
  defp context_line({:tag, text, values}, settings) do
    {make_span(text, values, settings), settings}
  end
  defp context_line(error, settings) do
    {error, settings}
  end

  defp make_span(text, [size, weight, color], settings) do
    ~s[<span style="color: #{make_color(color, settings)}; font-size: #{size}pt; font-weight: #{weight};">#{text}</span>] 
  end

  defp default_values, do: %{
    "scales" => 100,
    "gamma"  => 2.2,
    "div-claesses" => "earmark-tag-cloud",
    "font-family"  => "Arial"
  }
end
