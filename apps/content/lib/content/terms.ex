defmodule Legendary.Content.Terms do
  @moduledoc """
    This module contains functions for retrieving, manipulating, and saving
    Terms.
  """

  import Ecto.Query

  def categories do
    from t in Legendary.Content.Term,
      join: tt in Legendary.Content.TermTaxonomy,
      on: t.id == tt.term_id,
      where: tt.taxonomy ==  "category"
  end
end
