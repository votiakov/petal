defmodule CoreEmailTest do
  use Legendary.Core.DataCase

  import Legendary.CoreEmail

  test "base_email/1" do
    assert %Bamboo.Email{} = base_email()
  end
end
