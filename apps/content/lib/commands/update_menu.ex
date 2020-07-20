defmodule Content.UpdateMenu do
  alias Content.{Menu, Post, Postmeta, Repo, TermRelationship}
  alias Ecto.Multi

  import Ecto.Query

  def run(id, new_menu_params) do
    current_posts = Menu.nav_menu_items_for_id(id)
    post_ids_in_new_menu = recursive_post_ids(new_menu_params)
    deleted_post_ids =
      current_posts
      |> Enum.reject(& &1."ID" in post_ids_in_new_menu)
      |> Enum.map(& &1."ID")

    Multi.new()
    |> process_nodes(id, 0, new_menu_params |> add_order())
    |> Multi.delete_all(:stale_nodes, from(p in Post, where: p."ID" in ^deleted_post_ids))
    |> Repo.transaction()
  end

  def add_order(tree) do
    {_next_order, nodes} = add_order_starting_at(tree, 1)

    nodes
  end

  def add_order_starting_at(tree, starting_at) do
    tree
    |> Enum.reduce({starting_at, []}, fn node, {order, new_nodes} ->
      {next_order, new_child_nodes} = add_order_starting_at(node["children"], order + 1)
      new_node =
        node
        |> Map.merge(%{
          "order" => order,
          "children" => new_child_nodes,
        })
      {next_order, new_nodes ++ [new_node]}
    end)
  end

  defp process_nodes(multi, menu_id, parent_id, nodes) do
    nodes
    |> Enum.reduce(multi, fn node, m ->
      case node["post_id"] do
        nil ->
          create_node(m, menu_id, parent_id, node)
        _id ->
          update_node(m, menu_id, parent_id, node)
      end
    end)
  end

  defp create_node(multi, menu_id, parent_id, node) do
    post =
      Post.changeset(
        %Post{},
        %{
          post_author: 1,
          post_title: node["title"],
          post_status: "publish",
          comment_status: "closed",
          ping_status: "closed",
          menu_order: node["order"],
          post_type: "nav_menu_item",
          comment_count: 0,
        }
      )

    step_name = "#{parent_id}.create_node.#{node["order"]}"

    multi
    |> Multi.insert(step_name, post)
    |> Multi.run("#{step_name}.term_relationship", fn _repo, %{^step_name => post} ->
      tr =
        TermRelationship.changeset(
          %TermRelationship{},
          %{
            object_id: post."ID",
            term_taxonomy_id: menu_id,
            term_order: 0,
          }
        )

      Repo.insert(tr)
    end)
    |> Multi.merge(fn %{^step_name => post} ->
      Multi.new()
      |> insert_metas(type_of_node(node), post, parent_id, node)
    end)
    |> Multi.merge(fn %{^step_name => post} ->
      Multi.new()
      |> process_nodes(menu_id, post."ID", node["children"])
    end)
  end

  defp insert_metas(multi, "post", post, parent_id, node) do
    multi
    |> update_meta(post."ID", "_menu_item_type", "post_type")
    |> update_meta(post."ID", "_menu_item_object", "page")
    |> update_meta(post."ID", "_menu_item_object_id", node["target_id"])
    |> update_meta(post."ID", "_menu_item_menu_item_parent", parent_id)
  end

  defp insert_metas(multi, "category", post, parent_id, node) do
    multi
    |> update_meta(post."ID", "_menu_item_type", "taxonomy")
    |> update_meta(post."ID", "_menu_item_object", "category")
    |> update_meta(post."ID", "_menu_item_object_id", node["target_id"])
    |> update_meta(post."ID", "_menu_item_menu_item_parent", parent_id)
  end

  defp insert_metas(multi, "link", post, parent_id, node) do
    multi
    |> update_meta(post."ID", "_menu_item_type", "custom")
    |> update_meta(post."ID", "_menu_item_object", "custom")
    |> update_meta(post."ID", "_menu_item_object_id", post."ID")
    |> update_meta(post."ID", "_menu_item_url", node["url"])
    |> update_meta(post."ID", "_menu_item_menu_item_parent", parent_id)
  end

  defp type_of_node(%{"url" => url}) when url != nil, do: "link"
  defp type_of_node(%{"related_item" => %{"resource" => "posts"}}), do: "post"
  defp type_of_node(%{"related_item" => %{"resource" => "category"}}), do: "category"

  defp update_node(multi, menu_id, parent_id, node) do
    multi
    |> update_meta(node["post_id"], "_menu_item_menu_item_parent", parent_id)
    |> update_order(node["post_id"], node["order"])
    |> process_nodes(menu_id, node["post_id"], node["children"])
  end

  defp update_meta(multi, post_id, meta_key, new_value) when is_integer(new_value),
    do: update_meta(multi, post_id, meta_key, new_value |> Integer.to_string())

  defp update_meta(multi, post_id, meta_key, new_value) do
    step_name = "#{post_id}.update_meta.#{meta_key}"
    type = Postmeta.__schema__(:type, :meta_value)
    cast_value = Ecto.Type.cast(type, new_value)

    Postmeta
    |> where([pm], pm.meta_key == ^meta_key)
    |> where([pm], pm.post_id == ^post_id)
    |> Repo.one()
    |> case do
      nil ->
        multi
        |> Multi.insert(
          step_name,
          Postmeta.changeset(
            %Postmeta{},
            %{
              post_id: post_id,
              meta_key: meta_key,
              meta_value: new_value
            }
          )
        )
      %{meta_value: ^cast_value} ->
        # No change needed
        multi
      meta ->
        multi
        |> Multi.update(step_name, Postmeta.changeset(meta, %{meta_value: new_value}))
    end
  end

  defp update_order(multi, post_id, new_order) do
    step_name = "#{post_id}.update_order"

    multi
    |> Multi.update_all(step_name, from(p in Post, where: p."ID" == ^post_id), [set: [menu_order: new_order]])
  end

  defp recursive_post_ids(params) do
    params
    |> Enum.flat_map(& [&1["post_id"]|recursive_post_ids(&1["children"])])
  end
end
