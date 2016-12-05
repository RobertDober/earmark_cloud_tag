defmodule EarmarkTagCloud.Renderer do
  
  import EarmarkTagCloud.GammaCorrection
  
  def render(parsed_lines) do 
    parsed_lines
    |> Enum.reduce({[], default_values}, &remove_and_calc_settings/2)
    |> format_lines({["</div>"], []})
  end


  defp format_lines({[],settings},{output_lines, errors}), do: { [div_line(settings)|output_lines], errors }
  defp format_lines({[{:tag, text, params, lnb} | rest], settings}, {output, errors}) do 
    case make_span(text, params, settings) do
      {:error, _, msg} -> format_lines({rest, settings}, {output, [{:error, lnb, msg}|errors]})
      {:ok, span}      -> format_lines({rest, settings}, {[span|output], errors})
    end
  end
  defp format_lines({[err|rest], settings}, {output, errors}) do
    format_lines({rest, settings}, {output, [err|errors]})
  end

  defp remove_and_calc_settings({:set, key, value}, {output, settings}) do
    {output, Map.put(settings, key, value)}
  end 
  defp remove_and_calc_settings({:tag, _, _, _} = tag , {output, settings}) do
    # {make_span(text, values, settings), settings}
    {[tag | output], settings}
  end
  defp remove_and_calc_settings(error, {output, settings}) do
    {[error | output], settings}
  end

  defp div_line(settings) do
    ~s(<div #{div_id(settings)}class="#{settings["div-classes"]}" style="font-family: #{settings["font-family"]};">)
  end
  defp div_id(%{"div-id" => div_id}), do: ~s(id="#{div_id}" )
  defp div_id(_), do: ""

  defp make_span(text, [size, weight, gray_scale], settings) do
    case make_gray(gray_scale, settings) do
      {:error, message} -> {:error, text, message}
      {:ok, gray}       -> {:ok, ~s[  <span style="color: ##{gray}; font-size: #{size}pt; font-weight: #{weight};">#{text}</span>]}
    end
  end

  defp default_values, do: %{
    "scales"      => 12,
    "gamma"       => 2.2,
    "div-classes" => "earmark-tag-cloud",
    "font-family" => "Arial"
  }
end
