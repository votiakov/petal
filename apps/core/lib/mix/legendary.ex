defmodule Mix.Legendary do
  @moduledoc """
  Parent module for all Legendary framework mix tasks. Provides some helpers
  used by tasks and generators.
  """
  alias Mix.Phoenix.{Schema}

  @doc false
  def inputs(%Schema{} = schema) do
    Enum.map(schema.attrs, fn
      {_, {:references, _}} ->
        nil
      {key, :integer} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :number_input %>)
      {key, :float} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :number_input, step: "any" %>)
      {key, :decimal} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :number_input, step: "any" %>)
      {key, :boolean} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :checkbox %>)
      {key, :text} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :textarea %>)
      {key, :date} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :date_select %>)
      {key, :time} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :time_select %>)
      {key, :utc_datetime} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :datetime_select %>)
      {key, :naive_datetime} ->
        ~s(<%= styled_input f, #{inspect(key)}, input_helper: :datetime_select %>)
      {key, {:array, :integer}} ->
        ~s(<%= styled_input f, #{inspect(key)}, [input_helper: :multiple_select], ["1": 1, "2": 2] %>)
      {key, {:array, _}} ->
        ~s(<%= styled_input f, #{inspect(key)}, [input_helper: :multiple_select], ["Option 1": "option1", "Option 2": "option2"] %>)
      {key, _}  ->
        ~s(<%= styled_input f, #{inspect(key)} %>)
    end)
  end
end
