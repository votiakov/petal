defmodule AppWeb.LayoutView do
  use AppWeb, :view

  def title(view_module, template, assigns) do
    delegate_with_default(view_module, :title, [view_module, template, assigns], Legendary.I18n.t!("en", "site.title"))
  end

  def excerpt(view_module, template, assigns) do
    delegate_with_default(view_module, :excerpt, [view_module, template, assigns], Legendary.I18n.t!("en", "site.excerpt"))
  end

  def feed_tag(conn, view_module, view_template, assigns) do
    delegate_with_default(view_module, :feed_tag, [conn, view_module, view_template, assigns], nil)
  end

  defp delegate_with_default(nil, _, _, default), do: default
  defp delegate_with_default(view_module, function_name, args, default) do
    sibling_layout = sibling_layout_view(view_module)
    if function_exported?(sibling_layout, function_name, args |> Enum.count()) do
      apply(sibling_layout, function_name, args)
    else
      default
    end
  end

  defp sibling_layout_view(view_module) do
    view_module
    |> parent_module()
    |> Module.concat("LayoutView")
  end

  defp parent_module(mod) do
    [_|tail] = Module.split(mod) |> Enum.reverse()

    tail
    |> Enum.reverse()
    |> Module.concat()
  end
end
