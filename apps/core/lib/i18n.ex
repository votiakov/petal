defmodule Legendary.I18n do
  @moduledoc """
  The internationalization and strings module. Keeps strings outside the codebase and allows them to
  be replaced on a per locale basis by editing yml files.
  """
  use Linguist.Vocabulary

  Path.join(["../../config/i18n", "*.yml"])
  |> Path.wildcard()
  |> Enum.each(fn path ->
    locale =
      path
      |> Path.basename()
      |> Path.rootname()
      |> String.to_atom()

    locale locale, path
  end)
end
