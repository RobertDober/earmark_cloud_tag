defmodule EarmarkTagCloud.Parser.ParseLineTest do
  use ExUnit.Case
  
  import EarmarkTagCloud.Parser

  doctest EarmarkTagCloud.Parser

  describe "legal tag specifications" do
    test "explicit color" do
      assert parse_with_lnb("elixir 1 2 3") == {:tag, "elixir", [1, 2, 3], 1}
    end
  end

  describe "legal paramerer setters" do
    test "key value" do
      assert parse_with_lnb("set font-family Helvetica sans serif") == {:set, "font-family", "Helvetica sans serif"}
    end
    test "key int value" do
      assert parse_with_lnb("set scales 20") == {:set, "scales", 20}
    end
    test "key float value" do
      assert parse_with_lnb("set gamma 2") == {:set, "gamma", 2.0}
    end
    test "missing value" do
      assert parse_with_lnb("set font-family") == {:error, 1, "missing value for variable \"font-family\""}
    end
  end

  defp parse_with_lnb(line), do: parse_line({line, 1})
end
