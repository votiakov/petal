defmodule <%= inspect context.module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>View do
  use <%= inspect context.module %>, :view
end
