defmodule Mix.LegendaryTest do
  use Legendary.Core.DataCase

  alias Mix.Phoenix.{Schema}

  import Mix.Legendary

  def schema do
    %Schema{
      attrs: [
        reference: {:references, :foobar},
        integer: :integer,
        float: :float,
        decimal: :decimal,
        boolean: :boolean,
        text: :text,
        date: :date,
        time: :time,
        utc_datetime: :utc_datetime,
        naive_datetime: :naive_datetime,
        array_of_integers: {:array, :integer},
        array_of_strings: {:array, :string},
        other: :other,
      ]
    }
  end

  test "inputs/1" do
    [
      reference_input,
      integer_input,
      float_input,
      decimal_input,
      boolean_input,
      text_input,
      date_input,
      time_input,
      utc_datetime_input,
      naive_datetime_input,
      integer_array_input,
      array_input,
      other_input,
    ] = inputs(schema())

    assert reference_input == nil
    assert integer_input =~ ~s(number_input)
    assert float_input =~ ~s(number_input)
    assert decimal_input =~ ~s(number_input)
    assert boolean_input =~ ~s(checkbox)
    assert text_input =~ ~s(textarea)
    assert date_input =~ ~s(date_select)
    assert time_input =~ ~s(time_select)
    assert utc_datetime_input =~ ~s(datetime_select)
    assert naive_datetime_input =~ ~s(datetime_select)
    assert integer_array_input =~ ~s(multiple_select)
    assert array_input =~ ~s(multiple_select)
    assert other_input =~ ~s(:other %>)
  end
end
