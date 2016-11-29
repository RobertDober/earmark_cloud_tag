defmodule EarmarkTagCloud.Renderer do
  
  import EarmarkTagCloud.GammaCorrection
  
  def render(parsed_lines) do 
    with context_lines <- parsed_lines |> make_context() do
    end
  end

  def make_context(parsed_lines) do
    with {lines, settings} <- parsed_lines |> Enum.map_reduce(default_values, &context_line/2) do
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

  defp make_span(text, [size, weight, gray_scale], settings) do
    case make_gray(gray_scale, settings) do
      {:error, message} -> {:error, text, message}
      {:ok, gray} -> ~s[<span style="color: ##{gray}; font-size: #{size}pt; font-weight: #{weight};">#{text}</span>] 
    end
  end

  defp default_values, do: %{
    "scales" => 12,
    "gamma"  => 2.2,
    "div-claesses" => "earmark-tag-cloud",
    "font-family"  => "Arial"
  }
end
