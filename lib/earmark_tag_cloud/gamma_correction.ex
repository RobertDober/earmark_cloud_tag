defmodule EarmarkTagCloud.GammaCorrection do
  
  @doc """
    Make an RGB string for the given gray_scale of a number of scales and a given gamma correction
    according to this formula:

        255 * ( gray_scale / scales ) ^ ( 1 / gamma )

    Gamma defaults to 2.2 and you should only change it if the results are not satisfactory.

    See the following [Wikipedia article](https://en.wikipedia.org/wiki/Gamma_correction) for more information.

    Therefore

        iex> make_gray(99, %{"scales" => 100, "gamma" => 2.2})
        {:ok, "1f1f1f"}

        iex> make_gray(0, %{"scales" => 100, "gamma" => 2.2})
        {:ok, "ffffff"}

        iex> make_gray(10, %{"scales" => 12, "gamma" => 2.2})
        {:ok, "717171"}

        iex> make_gray(13, %{"scales" => 12, "gamma" => 2.2})
        {:error, "gray scale value 13 is out of range (0..12)"}

     Or, if you must

        iex> make_gray(42, %{"scales" => 99, "gamma" => 1.9})
        {:ok, "bfbfbf"}
   
  """
  def make_gray(gray_scale, %{"scales" => scales, "gamma" => gamma}) when gray_scale > scales do
    {:error, "gray scale value #{gray_scale} is out of range (0..#{scales})"}
  end 
  def make_gray(gray_scale, %{"scales" => scales, "gamma" => gamma}) do
    gamma_correct((scales - gray_scale) / scales, gamma)
  end

  
  defp gamma_correct(gray, gamma) do
    with rgbf = 255 * :math.pow(gray, 1 / gamma) do
      {:ok, rgbf
        |> round()
        |> Integer.to_string(16)
        |> String.pad_leading(2, "00")
        |> String.duplicate(3)
        |> String.downcase()
      }
    end
  end
end
