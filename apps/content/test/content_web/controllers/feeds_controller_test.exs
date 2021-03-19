defmodule Legendary.Content.FeedsControllerTest do
  use Legendary.Content.ConnCase

  alias Legendary.Content.{Term, TermRelationship, TermTaxonomy, Posts, Repo}

  @post_attrs %{
    id: 456,
    title: "Test post",
    type: "post",
    name: "blergh",
    status: "publish",
    date: ~N[2020-02-01T00:00:00],
  }
  @post_category %Term{
    id: 42,
    name: "Test Category",
    slug: "test-category",
  }
  @post_category_taxonomy %TermTaxonomy{
    id: 64,
    term_id: 42,
    taxonomy: "category",
    description: "A test category",
    parent: 0,
  }
  @post_category_relationship %TermRelationship{
    term_taxonomy_id: 64,
    object_id: 456,
  }

  def fixture(:category) do
    {:ok, category} = @post_category |> Repo.insert()
    {:ok, _term_taxonomy} = @post_category_taxonomy |> Repo.insert()
    {:ok, _term_relationship} = @post_category_relationship |> Repo.insert()
    category
  end

  def fixture(:post) do
    {:ok, post} = Posts.create_posts(@post_attrs)
    post
  end

  setup %{conn: conn} do

    %{
      conn: conn,
      post: fixture(:post),
      category: fixture(:category),
    }
  end

  describe "feeds" do
    test "index/2 without category", %{conn: conn} do
      conn = get conn, Routes.index_feed_path(conn, :index)

      assert response(conn, 200) =~ "<item>"
    end

    test "index/2 with category", %{conn: conn} do
      conn = get conn, Routes.category_feed_path(conn, :index, "test-category")

      assert response(conn, 200) =~ "<item>"
    end
  end
end
