defmodule Content.MenuTest do
  use Content.DataCase

  alias Content.{Menu, Option, Post, Postmeta, Repo, Term, TermRelationship}

  @theme_option %Option{
    option_name: "test_theme",
    option_value: "a:1:{s:18:\"nav_menu_locations\";a:1:{s:3:\"top\";i:13;}}"
  }

  @term_relationship %TermRelationship{
    term_taxonomy_id: 13,
    object_id: 123,
  }

  @top_nav_item %Post{
    ID: 123,
    post_name: "home",
    post_title: "Home",
    post_content: "",
    post_status: "publish",
    post_type: "nav_item",
    post_date: ~N"2018-01-01T00:00:00",
    comment_status: "open",
  }

  @top_nav_metas [
    %{
      post_id: 123,
      meta_key: "_menu_item_object_id",
      meta_value: "456",
    },
    %{
      post_id: 123,
      meta_key: "_menu_item_object",
      meta_value: "post",
    },
    %{
      post_id: 123,
      meta_key: "_menu_item_menu_item_parent",
      meta_value: "0",
    },
  ]

  @category_nav_metas [
    %{
      post_id: 123,
      meta_key: "_menu_item_object_id",
      meta_value: "42",
    },
    %{
      post_id: 123,
      meta_key: "_menu_item_object",
      meta_value: "category",
    },
    %{
      post_id: 123,
      meta_key: "_menu_item_menu_item_parent",
      meta_value: "0",
    },
  ]

  @related_page %Post {
    ID: 456,
    post_title: "Test Nav Home",
  }

  @related_category %Term{
    term_id: 42,
    name: "Test Category",
    slug: "test-category",
  }

  def fixture(:option) do
    @theme_option |> Repo.insert()
  end

  def fixture(:menu) do
    {:ok, option} = fixture(:option)
    {:ok, _term_relationship} = @term_relationship |> Repo.insert()
    {:ok, _nav_item} = @top_nav_item |> Repo.insert()
    {3, nil} = Repo.insert_all(Postmeta, @top_nav_metas)
    {:ok, _post} = @related_page |> Repo.insert()
    option
  end

  def fixture(:category_menu) do
    {:ok, option} = fixture(:option)
    {:ok, _term_relationship} = @term_relationship |> Repo.insert()
    {:ok, _nav_item} = @top_nav_item |> Repo.insert()
    {3, nil} = Repo.insert_all(Postmeta, @category_nav_metas)
    {:ok, _category} = @related_category |> Repo.insert()
    option
  end

  describe "get_menu_from_option_and_location" do
    test "returns an empty if the menu is not present" do
      fixture(:option)
      assert Menu.get_menu_from_option_and_location("test_theme", "top") == []
    end

    test "returns items if the menu is present" do
      fixture(:menu)
      menu = Menu.get_menu_from_option_and_location("test_theme", "top")
      refute menu == []
      assert (menu |> Enum.at(0)) == %{
        children: [],
        parent_id: "0",
        post_id: 123,
        related_item: %{resource: "posts", slug: nil, title: "Test Nav Home"},
        target_id: "456",
        type: "post",
        url: nil,
      }
    end

    test "returns items if the menu has a category" do
      fixture(:category_menu)
      menu = Menu.get_menu_from_option_and_location("test_theme", "top")
      refute menu == []
      assert (menu |> Enum.at(0)) == %{
        children: [],
        parent_id: "0",
        post_id: 123,
        related_item: %{resource: "category", slug: "test-category", title: "Test Category"},
        target_id: "42",
        type: "category",
        url: nil,
      }
    end
  end

  describe "put_menu_option" do
    test "it can change the active menu in a position" do
      fixture(:menu)

      {:ok, _option} = Menu.put_menu_option("test_theme", "top", 7) |> Repo.update()
      assert Menu.get_menu_from_option_and_location("test_theme", "top") == []
    end
  end
end
