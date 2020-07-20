defmodule Content.ShortcodesTest do
  use ExUnit.Case

  import Content.Shortcodes

  describe "shortcodes" do
    test "no shortcodes, no problem" do
      assert expand_shortcodes("test") == "test"
    end

    test "double bracket escapes work" do
      assert expand_shortcodes("[[test]]") == "[test]"
    end

    test "escapes enclosing shortcodes" do
      assert expand_shortcodes("[[test] abc [/test]]") == "[test] abc [/test]"
    end

    test "escapes shortcodes with args" do
      assert expand_shortcodes("[[test with-args][/test]]") == "[test with-args][/test]"
    end

    test "expands shortcodes" do
      assert expand_shortcodes("[test]") == "TSET"
    end

    test "expands shortcodes in the middle" do
      assert expand_shortcodes("this is a [test] of the shortcode system") == "this is a TSET of the shortcode system"
    end

    test "expands shortcodes at the end" do
      assert expand_shortcodes("this is a [test]") == "this is a TSET"
    end

    test "expands shortcodes at the beginning" do
      assert expand_shortcodes("[test] it up") == "TSET it up"
    end

    test "handles shortcodes with args" do
      assert expand_shortcodes("[test with-args]") == "TSET"
    end

    test "handles enclosing shortcodes" do
      assert expand_shortcodes("[test]Content[/test]") == "TNETNOC"
    end

    test "handles enclosing shortcodes with args" do
      assert expand_shortcodes("[test with-args]Content[/test]") == "TNETNOC"
    end

    test "handles enclosing shortcodes with no content" do
      assert expand_shortcodes("[test with-args][/test]") == ""
    end

    test "handles strings with carriage returns" do
      assert expand_shortcodes(" | \r\n ") == " | \n "
    end

    test "handles strings with high unicode characters" do
      assert expand_shortcodes("—") == "—"
    end

    test "handles shortcodes within tags" do
      assert expand_shortcodes("<p>[test]<em>chacha</em></p>") == "<p>TSET<em>chacha</em></p>"
    end

    test "handles mangled shortcodes gracefully" do
      assert expand_shortcodes("[[unclosed shortcode") == "[[unclosed shortcode"
    end
  end
end
