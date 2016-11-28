defmodule EarmarkTagCloud.Parser.ParseTagTest do
  use ExUnit.Case
  
  import EarmarkTagCloud.Parser

  doctest EarmarkTagCloud.Parser

  describe "legal tag specifications" do
    test "explicit color" do
      assert parse_line("elixir 1 2 3") == {:tag, "elixir", [1, 2, 3]}
    end
  end

  describe "legal paramerer setters" do
    test "key value" do
      assert parse_line("set font-family Helvetica sans serif") == {:set, "font-family", "Helvetica sans serif"}
    end
    test "missing value" do
      assert parse_line("set font-family") == {:error, "set font-family", "missing value for variable \"font-family\""}
    end
  end
end
