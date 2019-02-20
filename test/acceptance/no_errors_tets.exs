defmodule Acceptance.NoErrorsTest do
  use ExUnit.Case
  import Support.Render

  describe "no tags" do
    test "empty" do
      lines = []
      assert render_lines(lines) == {["<div class=\"earmark-tag-cloud\">\n", "</div>\n"],[]}
      
    end
    test "settings do not matter" do
      lines = ["set font-family Whatever U want"]
      assert render_lines(lines) == {["<div class=\"earmark-tag-cloud\" style=\"font-family: Whatever U want;\">\n", "</div>\n"],[]}
    end
    # TODO: v0.2 return errors for unsupported keys
    test "illegal keys are not intercepted (in v0.1 at least)" do
      lines = ["set the-answer 42", "set font-family Helvetica"]
      assert render_lines(lines) == {["<div class=\"earmark-tag-cloud\" style=\"font-family: Helvetica;\">\n", "</div>\n"],[]}
    end
  end

  describe "no errors, default settings" do
    test "one tag" do
      lines = [ "elixir rocks 30 900 6"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\">\n",
        "  <span style=\"color: #bababa; font-size: 30pt; font-weight: 900;\">elixir rocks</span>\n",
        "</div>\n"
      ], []} 

      assert render_lines(lines) == expected
    end
    test "two tags" do
      lines = ["set font-family Arial", "ruby 10 200 3", "elixir 30 400 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\" style=\"font-family: Arial;\">\n",
        "  <span style=\"color: #e0e0e0; font-size: 10pt; font-weight: 200;\">ruby</span>\n",
        "  <span style=\"color: #c8c8c8; font-size: 30pt; font-weight: 400;\">elixir</span>\n",
        "</div>\n"
      ], []} 

      assert render_lines(lines) == expected
    end
  end

  describe "no errors, custom settings" do
    test "set before" do
      lines = ["set scales 50", "ruby 10 200 50", "elixir 30 400 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\">\n",
        "  <span style=\"color: #000000; font-size: 10pt; font-weight: 200;\">ruby</span>\n",
        "  <span style=\"color: #f3f3f3; font-size: 30pt; font-weight: 400;\">elixir</span>\n",
        "</div>\n"
      ], []} 

      assert render_lines(lines) == expected
    end
    test "set in between" do
      lines = [ "ruby 10 200 50", "set scales 50", "elixir 30 400 5"]
      expected = 
      {[ "<div class=\"earmark-tag-cloud\">\n",
        "  <span style=\"color: #000000; font-size: 10pt; font-weight: 200;\">ruby</span>\n",
        "  <span style=\"color: #f3f3f3; font-size: 30pt; font-weight: 400;\">elixir</span>\n",
        "</div>\n"
      ], []} 

      assert render_lines(lines) == expected
    end
    test "set after" do
      lines = ["ruby 10 200 50", " set div-classes alpha", "elixir 30 400 5", "set scales 50", "set div-classes beta and gamma"]
      expected = 
      {[ "<div class=\"beta and gamma\">\n",
        "  <span style=\"color: #000000; font-size: 10pt; font-weight: 200;\">ruby</span>\n",
        "  <span style=\"color: #f3f3f3; font-size: 30pt; font-weight: 400;\">elixir</span>\n",
        "</div>\n"
      ], []} 

      assert render_lines(lines) == expected
    end
  end

end
