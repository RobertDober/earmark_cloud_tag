defmodule EarmarkTagCloudTest do
  use ExUnit.Case
  import Support.Render

  describe "no tags" do
    test "empty" do
      lines = []
      assert render_lines(lines) == {["<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">", "</div>"],[]}
      
    end
    test "settings do not matter" do
      lines = ["set font-family Whatever U want"]
      assert render_lines(lines) == {["<div class=\"earmark-tag-cloud\" style=\"font-family: Whatever U want;\">", "</div>"],[]}
    end
    # TODO: v0.2 return errors for unsupported keys
    test "illegal keys are not intercepted (in v0.1 at least)" do
      lines = ["set the-answer 42"]
      assert render_lines(lines) == {["<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">", "</div>"],[]}
    end
  end

  describe "no errors, default settings" do
    test "one tag" do
      lines = [ "elixir rocks 30 900 6"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">",
        "  <span style=\"color: #bababa; font-size: 30pt; font-weight: 900;\">elixir rocks</span>",
        "</div>"
      ], []} 

      assert render_lines(lines) == expected
    end
    test "two tags" do
      lines = ["ruby 10 200 3", "elixir 30 400 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">",
        "  <span style=\"color: #e0e0e0; font-size: 10pt; font-weight: 200;\">ruby</span>",
        "  <span style=\"color: #c8c8c8; font-size: 30pt; font-weight: 400;\">elixir</span>",
        "</div>"
      ], []} 

      assert render_lines(lines) == expected
    end
  end

  describe "no errors, custom settings" do
    test "set before" do
      lines = ["set scales 50", "ruby 10 200 50", "elixir 30 400 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">",
        "  <span style=\"color: #000000; font-size: 10pt; font-weight: 200;\">ruby</span>",
        "  <span style=\"color: #f3f3f3; font-size: 30pt; font-weight: 400;\">elixir</span>",
        "</div>"
      ], []} 

      assert render_lines(lines) == expected
    end
    test "set in between" do
      lines = [ "ruby 10 200 50", "set scales 50", "elixir 30 400 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">",
        "  <span style=\"color: #000000; font-size: 10pt; font-weight: 200;\">ruby</span>",
        "  <span style=\"color: #f3f3f3; font-size: 30pt; font-weight: 400;\">elixir</span>",
        "</div>"
      ], []} 

      assert render_lines(lines) == expected
    end
    test "set after" do
      lines = ["ruby 10 200 50", " set div-classes alpha", "elixir 30 400 5", "set scales 50", "set div-classes beta and gamma"]
      expected = 
      {[ "<div class=\"beta and gamma\" style=\"font-family: Arial;\">",
        "  <span style=\"color: #000000; font-size: 10pt; font-weight: 200;\">ruby</span>",
        "  <span style=\"color: #f3f3f3; font-size: 30pt; font-weight: 400;\">elixir</span>",
        "</div>"
      ], []} 

      assert render_lines(lines) == expected
    end
  end

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
      {[ "<div id=\"hello-world\" class=\"earmark-tag-cloud\" style=\"font-family: Helvetica U Name It;\">",
        "  <span style=\"color: #f8f8f8; font-size: 12pt; font-weight: 100;\">elixir is king</span>",
        "  <span style=\"color: #3b3b3b; font-size: 14pt; font-weight: 200;\">set</span>",
        "</div>"
      ], [
        {:error, 89, "missing one or more of necessary integer values (font-size font-weight gray-scale) at end of tag specifcation"},
        {:error, 92, "value for gray-scale out of legal range. Actual: 51, Allowed: 0..50"}
      ]} 

      assert render_lines(lines, 85) == expected
    end

  end
end
