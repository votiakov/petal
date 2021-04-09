defmodule AppWeb.LayoutView do
  use AppWeb, :view

  def title(_, _, _) do
    Legendary.I18n.t!("en", "site.title")
   end

   def excerpt(_, _, _) do
     Legendary.I18n.t!("en", "site.excerpt")
   end

   def feed_tag(_, _, _, _) do
     nil
   end
end
