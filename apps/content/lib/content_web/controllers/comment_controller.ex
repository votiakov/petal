defmodule Content.CommentController do
  use Content, :controller

  alias Content
  alias Content.Comments
  alias Content.Post
  alias Content.Repo

  import Ecto.Query

  def create(conn, %{"comment" => comment_params}) do
    comment_params = comment_params |> Map.merge(%{"comment_author_IP" => to_string(:inet_parse.ntoa(conn.remote_ip))})

    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        post =
          Post
          |> where([p], p.id == ^comment.comment_post_id)
          |> Repo.one()

        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.posts_path(conn, :show, post))
      {:error, _} ->
        post =
          Post
          |> where([p], p.id == ^comment_params["comment_post_id"])
          |> Repo.one()

        conn
        |> redirect(to: Routes.posts_path(conn, :show, post))
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        post =
          Post
          |> where([p], p.id == ^comment.comment_post_id)
          |> Repo.one()

        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.posts_path(conn, :show, post))
      {:error, _} ->
        post =
          Post
          |> where([p], p.id == ^comment_params["comment_post_id"])
          |> Repo.one()

        conn
        |> redirect(to: Routes.posts_path(conn, :show, post))
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, comment} = Comments.delete_comment(comment)
    post =
      Post
      |> where([p], p.id == ^comment.comment_post_id)
      |> Repo.one()

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.posts_path(conn, :show, post))
  end
end
