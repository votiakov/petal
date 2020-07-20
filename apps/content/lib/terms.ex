defmodule Content.Terms do
  @moduledoc """
    This module contains functions for retrieving, manipulating, and saving
    Terms.
  """

  import Ecto.Query

  def categories do
    from t in Content.Term,
      join: tt in Content.TermTaxonomy,
      on: t.term_id == tt.term_id,
      where: tt.taxonomy ==  "category"
  end
end
