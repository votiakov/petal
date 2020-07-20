defmodule Content.Repo.Migrations.CreateWpSchema do
  use Ecto.Migration

  def change do
    create table("wp_commentmeta", primary_key: false) do
      add :meta_id, :serial, primary_key: true
      add :comment_id, :integer
      add :meta_key, :text
    end

    create table("wp_comments", primary_key: false) do
      add :comment_ID, :serial, primary_key: true
      add :comment_post_ID, :integer
      add :comment_author, :text
      add :comment_author_email, :text
      add :comment_author_url, :text
      add :comment_author_IP, :text
      add :comment_date, :naive_datetime
      add :comment_date_gmt, :naive_datetime
      add :comment_content, :string
      add :comment_karma, :integer
      add :comment_approved, :text
      add :comment_agent, :text
      add :comment_type, :text
      add :comment_parent, :integer
      add :user_id, :integer
    end

    create table("wp_links", primary_key: false) do
      add :link_id, :serial, primary_key: true
      add :link_url, :text
      add :link_name, :text
      add :link_image, :text
      add :link_target, :text
      add :link_description, :text
      add :link_visible, :text
      add :link_owner, :integer
      add :link_rating, :integer
      add :link_updated, :naive_datetime
      add :link_rel, :text
      add :link_rss, :text
    end

    create table("wp_options", primary_key: false) do
      add :option_id, :serial, primary_key: true
      add :option_name, :text
      add :autoload, :text
      add :option_value, :text
    end

    create table("wp_postmeta", primary_key: false) do
      add :meta_id, :serial, primary_key: true
      add :post_id, :integer
      add :meta_key, :text
      add :meta_value, :text
    end

    create table("wp_posts", primary_key: false) do
      add :ID, :integer, [:primary_key]
      add :post_author, :integer
      add :post_date, :naive_datetime
      add :post_date_gmt, :naive_datetime
      add :post_content, :text
      add :post_title, :string
      add :post_excerpt, :string
      add :post_status, :text
      add :comment_status, :text
      add :ping_status, :text
      add :post_password, :text
      add :post_name, :text
      add :to_ping, :string
      add :pinged, :string
      add :post_modified, :naive_datetime
      add :post_modified_gmt, :naive_datetime
      add :post_content_filtered, :text
      add :post_parent, :integer
      add :guid, :text
      add :menu_order, :integer
      add :post_type, :text
      add :post_mime_type, :text
      add :comment_count, :integer
    end

    create table("wp_term_relationships", primary_key: false) do
      add :object_id, :serial, primary_key: true
      add :term_taxonomy_id, :integer, [:primary_key]
      add :term_order, :integer
    end

    create table("wp_term_taxonomy", primary_key: false) do
      add :term_taxonomy_id, :serial, primary_key: true
      add :term_id, :integer
      add :taxonomy, :text
      add :description, :text
      add :parent, :integer
      add :count, :integer
    end

    create table("wp_termmeta", primary_key: false) do
      add :meta_id, :serial, primary_key: true
      add :term_id, :integer
      add :meta_key, :text
      add :meta_value, :text
    end

    create table("wp_terms", primary_key: false) do
      add :term_id, :serial, primary_key: true
      add :name, :text
      add :slug, :text
      add :term_group, :integer
    end

    create table("wp_usermeta", primary_key: false) do
      add :umeta_id, :serial, primary_key: true
      add :user_id, :integer
      add :meta_key, :text
      add :meta_value, :text
    end

    create table("wp_users", primary_key: false) do
      add :ID, :integer, [:primary_key]
      add :user_login, :text
      add :user_pass, :text
      add :user_nicename, :text
      add :user_email, :text
      add :user_url, :text
      add :user_registered, :naive_datetime
      add :user_activation_key, :text
      add :user_status, :integer
      add :display_name, :text
    end
  end
end
