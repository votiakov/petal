defmodule Content.Menu do
  @moduledoc """
  Module for retrieving, manipulating, and processing navigation menus.
  """
  alias Content.{Option, Post, Repo, Term, TermRelationship}
  import Ecto.Query

  def put_menu_option(option_name, location_name, menu_id) do
    option =
      Option
      |> where(option_name: ^option_name)
      |> Repo.one()
      |> Kernel.||(%Option{option_name: option_name, option_value: "a:0:{}"})

    value =
      option
      |> Option.parse_option_value

    nav_menu_locations =
      value
      |> Enum.find(fn {key, _value} -> key == "nav_menu_locations" end)
      |> Kernel.||({"nav_menu_locations", []})
      |> elem(1)

    new_nav_menu_locations =
      nav_menu_locations
      |> Enum.filter(fn {key, _value} -> key != location_name end)
      |> Kernel.++([{location_name, menu_id}])

    new_value =
      value
      |> Enum.filter(fn {key, _value} -> key != "nav_menu_locations" end)
      |> Kernel.++([{"nav_menu_locations", new_nav_menu_locations}])

    option
    |> Option.put_new_value(new_value)
  end

  def get_menu_from_option_and_location(option_name, location_name) do
    option =
      Option
      |> where(option_name: ^option_name)
      |> Repo.one()
      |> Kernel.||(%Option{option_name: option_name, option_value: "a:0:{}"})

    value =
      option
      |> Option.parse_option_value

    menu_pair =
      value
      |> Enum.find(fn {key, _value} -> key == "nav_menu_locations" end)
      |> Kernel.||({"nav_menu_locations", []})
      |> elem(1)
      |> Enum.find(fn {key, _value} -> key == location_name end)

    case menu_pair do
      {^location_name, menu_id} ->
        menu_id |> get_menu_from_id()
      nil ->
        nil
    end
  end

  def get_menu_from_id(menu_id) do
    menu_id
    |> nav_menu_items_for_id()
    |> arrange_menu_item_posts()
  end

  def nav_menu_items_for_id(menu_id) do
    Post
    |> join(
      :inner,
      [p],
      tr in TermRelationship,
      on: p."ID" == tr.object_id
    )
    |> order_by(:menu_order)
    |> preload(:metas)
    |> where([p, tr], tr.term_taxonomy_id == ^menu_id)
    |> Repo.all()
  end

  defp arrange_menu_item_posts(nav_posts, parent_id \\ "0", nav_to_post_map \\ nil) do
    nav_to_post_map = nav_to_post_map || make_nav_to_post_map(nav_posts)

    nav_posts
    |> Enum.filter(fn post ->
      meta_map = post |> Post.metas_map
      meta_map["_menu_item_menu_item_parent"] == parent_id
    end)
    |> Enum.map(fn post ->
      meta_map = post |> Post.metas_map
      related_item =
        if meta_map["_menu_item_object"] == "category" do
          item = nav_to_post_map["category/#{meta_map["_menu_item_object_id"]}"] || %Term{}

          %{
            title: item.name,
            slug: item.slug,
            resource: "category",
          }
        else
          item = nav_to_post_map["post/#{meta_map["_menu_item_object_id"]}"] || %Post{}

          %{
            title: item.post_title,
            slug: item.post_name,
            resource: "posts",
          }
        end

      %{
        post_id: post."ID",
        type: meta_map["_menu_item_object"],
        target_id: meta_map["_menu_item_object_id"],
        parent_id: meta_map["_menu_item_menu_item_parent"],
        url: meta_map["_menu_item_url"],
        related_item: related_item,
        children: arrange_menu_item_posts(nav_posts, Integer.to_string(post."ID"), nav_to_post_map),
      }
    end)
  end

  defp make_nav_to_post_map(nav_posts) do
    nav_post_meta_map = nav_posts |> Post.metas_map()

    linked_post_ids =
      nav_post_meta_map
      |> Enum.filter(fn {_key, value} ->
        value["_menu_item_object"] != "category"
      end)
      |> Enum.map(fn {_key, value} ->
        value["_menu_item_object_id"]
      end)

    nav_to_post_map =
      Post
      |> where([p], p."ID" in ^linked_post_ids)
      |> Repo.all()
      |> Enum.map(fn post ->
        {"post/#{post."ID"}", post}
      end)
      |> Map.new

    linked_category_ids =
      nav_post_meta_map
      |> Enum.filter(fn {_key, value} ->
        value["_menu_item_object"] == "category"
      end)
      |> Enum.map(fn {_key, value} ->
        value["_menu_item_object_id"]
      end)

    nav_to_category_map =
      Term
      |> where([t], t.term_id in ^linked_category_ids)
      |> Repo.all()
      |> Enum.map(fn category ->
        {"category/#{category.term_id}", category}
      end)
      |> Map.new

    nav_to_post_map |> Map.merge(nav_to_category_map)
  end
end
