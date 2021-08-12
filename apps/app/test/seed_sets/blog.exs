alias Legendary.Content.Post
alias Legendary.Content.Repo

%Post{
  title: "Public post",
  name: "public-post",
  status: "publish",
  type: "post",
  date: ~N[2020-01-01T00:00:00],
}
|> Repo.insert!()
