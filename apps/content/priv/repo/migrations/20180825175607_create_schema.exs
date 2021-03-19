defmodule Legendary.Content.Repo.Migrations.CreateSchema do
  use Ecto.Migration

  def change do
    create table("commentmeta") do
      add :comment_id, :integer
      add :key, :string
      add :value, :text
    end

    create table("comments") do
      add :post_id, :integer
      add :author, :text
      add :author_email, :text
      add :author_url, :text
      add :author_IP, :text
      add :date, :naive_datetime
      add :date_gmt, :naive_datetime
      add :content, :text
      add :karma, :integer
      add :approved, :text
      add :agent, :text
      add :type, :text
      add :parent, :integer
      add :user_id, :integer
    end

    create table("links") do
      add :url, :text
      add :name, :text
      add :image, :text
      add :target, :text
      add :description, :text
      add :visible, :text
      add :owner, :integer
      add :rating, :integer
      add :updated, :naive_datetime
      add :rel, :text
      add :rss, :text
      add :notes, :text
    end

    create table("options") do
      add :name, :text
      add :autoload, :text
      add :value, :text
    end

    create table("postmeta") do
      add :post_id, :integer
      add :key, :string
      add :value, :text
    end

    create table("posts") do
      add :author_id, :integer
      add :date, :naive_datetime
      add :date_gmt, :naive_datetime
      add :content, :text
      add :title, :string
      add :excerpt, :string
      add :status, :text
      add :comment_status, :text
      add :ping_status, :text
      add :password, :text
      add :name, :text
      add :to_ping, :string
      add :pinged, :string
      add :modified, :naive_datetime
      add :modified_gmt, :naive_datetime
      add :content_filtered, :text
      add :parent, :integer
      add :guid, :text
      add :menu_order, :integer
      add :type, :text
      add :mime_type, :text
      add :comment_count, :integer, default: 0
    end

    create unique_index(:posts, ["name"])

    create table("term_relationships", primary_key: false) do
      add :object_id, :serial, primary_key: true
      add :term_taxonomy_id, :integer, [:primary_key]
      add :term_order, :integer
    end

    create table("term_taxonomy") do
      add :term_id, :integer
      add :taxonomy, :text
      add :description, :text
      add :parent, :integer
      add :count, :integer
    end

    create table("termmeta") do
      add :term_id, :integer
      add :key, :string
      add :value, :text
    end

    create table("terms") do
      add :name, :text
      add :slug, :text
      add :term_group, :integer
    end
  end
end
