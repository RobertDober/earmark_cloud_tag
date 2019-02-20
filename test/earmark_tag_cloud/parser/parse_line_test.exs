defmodule EarmarkTagCloud.Parser.ParseLineTest do
  use ExUnit.Case
  
  import EarmarkTagCloud.Parser

  doctest EarmarkTagCloud.Parser

  describe "legal tag specifications" do
    test "implicit color" do
      assert parse_with_lnb("elixir 1 2 3") == {:tag, "elixir", [1, 2, 3], 1}
    end
    test "explicit color" do
      assert parse_with_lnb("elixir 1 2 #403020") == {:tag, "elixir", [1, 2, "403020"], 1}
    end
  end

  describe "illegal tag specifications" do
    test "incorrect color" do
      assert parse_with_lnb("ruby 10 100 #abcde") == {:error, 1, "missing one or more of necessary integer values (font-size font-weight gray-scale|color) at end of tag specifcation\n--> ruby 10 100 #abcde"}
    end
  end

  describe "legal parameter setters" do
    test "key value" do
      assert parse_with_lnb("set font-family Helvetica sans serif") == {:set, "font-family", "Helvetica sans serif"}
    end
    test "key int value" do
      assert parse_with_lnb("set scales 20") == {:set, "scales", 20}
    end
    test "key float value" do
      assert parse_with_lnb("set gamma 2") == {:set, "gamma", 2.0}
    end
  end

  describe "illegal parameter setters" do
    test "missing value" do
      assert parse_with_lnb("set font-family") == {:error, 1, "missing value for variable \"font-family\"\n--> set font-family"}
    end
    test "non numerical value" do
      assert parse_with_lnb("set scales hello") == {:error, 1, "illegal value \"hello\" for key \"scales\"\n--> set scales hello"}
    end
  end

  defp parse_with_lnb(line), do: parse_line({line, 1})
end
