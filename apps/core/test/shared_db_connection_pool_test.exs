defmodule Legendary.Core.SharedDBConnectionPoolTest do
  use Legendary.Core.DataCase

  import Legendary.Core.SharedDBConnectionPool

  test "child_spec/2" do
    spec = child_spec({Postgrex.Protocol, []})

    assert %{id: Legendary.Core.SharedDBConnectionPool, start: start} = spec
    assert {Legendary.Core.SharedDBConnectionPool, :start_link, [{Postgrex.Protocol, opts}]} = start
    assert [{:name, hashed_name}] = opts
    assert Atom.to_string(hashed_name) =~ "Legendary.Core.SharedDBConnectionPool."
  end
end
