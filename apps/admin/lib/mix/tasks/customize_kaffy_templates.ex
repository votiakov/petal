defmodule Mix.Tasks.Legendary.CustomizeKaffyTemplates do
  use Mix.Task

  @shortdoc "Overwrites kaffy templates with custom versions."
  def run(_) do
    base = Path.expand("lib/kaffy_web/templates/")

    replacements =
      base
      |> Path.join("**/*.eex")
      |> Path.wildcard()

    new_base =
      Mix.Project.deps_path()
      |> Path.join("kaffy/lib/kaffy_web/templates")

    replacements
    |> Enum.each(fn template_path ->
      File.copy(template_path, template_path |> String.replace(base, new_base))
    end)
  end
end
