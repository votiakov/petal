# Content Management

Your app includes a basic content management system including a simple blog
(including optional user comments), dynamic pages, and static pages.

Pages and blog posts can be managed from the admin interface. Posts and pages
support content in [Markdown](https://www.markdownguide.org/).

# Blog Posts

Your app has a blog at /blog. Your can create and manage posts from "Content > Pages and Posts"
in the /admin area. You can write your post body in Markdown.

By default, posts have a few fields:

- Type: for a blog post, this will be "Blog Post"
- Slug: this is the url path of your post. For example, a post with slug "hello-world"
would be available at /hello-world.
- Title: the human-readable title of your post.
- Content: this is the body of your post as Markdown. The admin provides a nice
editor in case you don't know Markdown syntax yet or don't want to bother.
- Status: this is Publish if you want your post to be visible to everyone, or draft
if you aren't ready to share it with the world.
- Author: this will normally be you, but we do allow admins to ghost-write for other
users.
- Excerpt: A short summary of your blog post that may show up in search engine results.
- Sticky: sticky posts will always show up first on your blog. They are generally used
for important announcements and community rules.
- Comment status: "open" will allow comments on your post. "closed" hides comments and
does not allow new comments to be entered.
- Ping status: whether the post supports (pingbacks)[https://en.wikipedia.org/wiki/Pingback].
**Coming soon:** we don't currently show pingbacks anywhere or notify anyone when a
pingback is received, but we may in the future.
- Menu order: **Coming soon:** the relative order this blog post will show up in
dynamic menus. Menu management is currently in development. The lower this number,
the higher the post will appear in the menu.

# Dynamic Pages

Dynamic pages are very similar to blog posts. The only differences are that their
type is "Page" instead of "Blog Post" and they do not appear in your blog feed.

They are intended for simple pages that will be updated by your admins, but don't
make sense as a blog post-- for example, terms of service or FAQ pages.

The fields of dynamic pages are the same as blog posts.

# Static Pages

Legendary also supports static pages. Static pages are not editable from the admin.
However, they provide an easy way for developers on a Legendary app to create
and serve a content page without defining custom controllers and routes. This is
a good fit for pages that are more complex than what can be done with Markdown
in dynamic pages.

Static pages are eex templates located in apps/content/lib/content_web/templates/posts/static_pages/.
For example, the home page of your app is a static page called index.html.eex.
The filename, less the .html.eex part, serves as the slug. In other words, a
static page called pricing.html.eex would have the url path /pricing in your app.

> Note: if a static page and a dynamic page have the same slug, the dynamic page
> will "win." This allows you to provide a default version of the page as a fallback
> in code, while allowing admins to create an updated version of the same page.

# Comments

As mentioned above, blog posts can optionally have comments enabled. On these posts,
there will be a feed of comments as well as a comment form at the bottom of the page.

Comments can be managed by admins in the admin interface under "Content > Comments."
