defmodule Content.ShortcodeParser do
  use Neotomex.ExGrammar

  @root true
  define :document, "(comment / shortcode / notcode)*" do
    tail ->
      tail |> Enum.join
  end

  define :notcode, "not_open_bracket+" do
    content ->
      content |> Enum.join
  end

  define :comment, "<open_bracket> <open_bracket> ([^\\]]+ close_bracket?)+ <close_bracket>" do
    [inner] ->
      inner
      |> Enum.map(fn [chars, nil] -> "#{chars |> Enum.join}]" end)
      |> Enum.join
      |> (&("[#{&1}")).()
  end

  define :shortcode, "<open_bracket> <spaces?> name <spaces?> attribute* <close_bracket> <!'('> (notcode? <open_bracket> <'/'> <spaces?> name <spaces?> <close_bracket>)?" do
    [name, attributes, nil] ->
      Content.Shortcodes.dispatch(name, attributes)
    [name, attributes, [content, closing_name]] when closing_name == name ->
      Content.Shortcodes.dispatch(name, attributes, content || "")
  end

  define :attribute, "name <spaces?>"
  define :name, "(namechar+)", do: (chars -> Enum.join(chars))
  define :namechar, "[A-Za-z0-9] / dash / underscore"
  define :dash, "<'-'>"
  define :underscore, "<'_'>"
  define :open_bracket, "<'['>", do: ["["]
  define :not_open_bracket, "[^\\[]"
  define :close_bracket, "<']'>", do: ["]"]
  define :close_comment, "close_bracket close_bracket"
  define :spaces, "[\s\\r\\n]*"

  @_neotomex_definitions Map.put(@_neotomex_definitions,
    :not_open_bracket,
    {{:terminal, ~r/^[^[]/u}, nil})
end

defmodule Content.Shortcodes do
  @moduledoc """
  For handling wordpress style shortcodes in strings.
  """
  def expand_shortcodes(frag) do
    {:ok, tree} = Floki.parse_fragment(frag)

    case tree do
      [text] when is_binary(text) ->
        {:ok, result} = processed_text(text) |> Floki.parse_fragment
        result
      _ ->
        tree
        |> Floki.traverse_and_update(fn
          tag ->
            tag |> transform_text_nodes
        end)
    end
    |> Floki.raw_html(encode: false)
  end

  defp transform_text_nodes({tag_name, attrs, children}) do
    new_children =
      children
      |> Enum.map(fn
        text when is_binary(text) ->
          {:ok, [result]} = processed_text(text) |> Floki.parse_fragment
          result
        other -> other
      end)
    {tag_name, attrs, new_children}
  end

  defp processed_text(text) do
    text =
      text
      |> String.replace("\r", "")

    case Content.ShortcodeParser.parse(text) do
      {:ok, result, remainder} ->
        [result, remainder] |> Enum.join
      {:ok, result} ->
        result
    end
  end

  def dispatch(tag, _attrs), do: String.upcase(String.reverse(tag))

  def dispatch(_tag, _attrs, content) do
    String.upcase(String.reverse(content))
  end
end
