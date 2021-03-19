defmodule Legendary.CoreWeb.EmailHelpers do
  @moduledoc """
  HTML helpers for emails.
  """

  import Phoenix.HTML, only: [sigil_E: 2]

  def framework_styles do
    %{
      background: %{
        color: "#222222",
      },
      body: %{
        font_family: "sans-serif",
        font_size: "15px",
        line_height: "20px",
        text_color: "#555555",
      },
      button: %{
        border_radius: "4px",
        border: "1px solid #000000",
        background: "#222222",
        color: "#ffffff",
        font_family: "sans-serif",
        font_size: "15px",
        line_height: "15px",
        text_decoration: "none",
        padding: "13px 17px",
        display: "block",
      },
      column: %{
        background: "#FFFFFF",
        padding: "0 10px 40px 10px",
      },
      footer: %{
        padding: "20px",
        font_family: "sans-serif",
        font_size: "12px",
        line_height: "15px",
        text_align: "center",
        color: "#ffffff",
      },
      global: %{
        width: 600,
      },
      h1: %{
        margin: "0 0 10px 0",
        font_family: "sans-serif",
        font_size: "25px",
        line_height: "30px",
        color: "#333333",
        font_weight: "normal",
      },
      h2: %{
        margin: "0 0 10px 0",
        font_family: "sans-serif",
        font_size: "18px",
        line_height: "22px",
        color: "#333333",
        font_weight: "bold",
      },
      header: %{
        padding: "20px 0",
        text_align: "center",
      },
      hero_image: %{
        background: "#dddddd",
        display: "block",
        margin: "auto",
      },
      inner_column: %{
        padding: "10px 10px 0",
      },
      li: %{
        margin: "0 0 0 10px",
      },
      last_li: %{
        margin: "0 0 10px 30px",
      },
      spacer: %{
        height: "40",
        font_size: "0px",
        line_height: "0px",
      },
      ul: %{
        margin: "0 0 10px 0",
        padding: "0",
      },
    }
  end

  def framework_styles(group) do
    Map.get(framework_styles(), group, %{})
  end

  def application_styles(group) do
    styles = Application.get_env(:core, :email, %{}) |> Map.get(:styles, %{})

    Map.get(styles, group, %{})
  end

  def effective_styles(group, overrides \\ %{}) do
    group
    |> framework_styles()
    |> Legendary.Core.MapUtils.deep_merge(application_styles(group))
    |> Map.merge(overrides)
  end

  def preview(do: content) do
    ~E"""
    <div style="max-height:0; overflow:hidden; mso-hide:all;" aria-hidden="true">
      <%= content %>
    </div>
    <!-- Visually Hidden Preheader Text : END -->

    <!-- Create white space after the desired preview text so email clients don’t pull other distracting text into the inbox preview. Extend as necessary. -->
    <!-- Preview Text Spacing Hack : BEGIN -->
    <div style="display: none; font-size: 1px; line-height: 1px; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden; mso-hide: all; font-family: sans-serif;">
        &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;
        &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;
        &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;
        &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;
        &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;
        &zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;
    </div>
    """
  end

  def header(do: content) do
    ~E"""
    <tr>
      <td style="<%= map_style(effective_styles(:header)) %>">
        <%= content %>
      </td>
    </tr>
    """
  end

  def spacer do
    style = effective_styles(:spacer)

    ~E"""
    <tr>
      <td aria-hidden="true" height="<%= style[:height] %>" style="<%= map_style(style) %>">
        &nbsp;
      </td>
    </tr>
    """
  end

  def row(do: content) do
    ~E"""
    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
      <tr>
        <%= content %>
      </tr>
    </table>
    """
  end

  @spec col(number, keyword, [{:do, any}, ...]) :: {:safe, [...]}
  def col(n, opts, do: content) do
    {of, _opts} = Keyword.pop!(opts, :of)
    width = n * 100.0 / of

    ~E"""
    <td valign="top" width="<%= width %>%" style="<%= map_style(effective_styles(:column)) %>">
      <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
          <td style="<%= map_style(effective_styles(:body)) %> <%= map_style(effective_styles(:inner_column)) %>">
            <%= content %>
          </td>
        </tr>
      </table>
    </td>
    """
  end

  def hero_image(opts) do
    {src, _rest_opts} = Keyword.pop!(opts, :src)

    ~E"""
    <%= row do %>
      <%= col 1, of: 1 do %>
        <img
          src="<%= src %>"
          width="<%= effective_styles(:global)[:width] %>"
          height="auto"
          alt="alt_text"
          border="0"
          style="
            <%= map_style(effective_styles(:body)) %>
            width: 100%;
            max-width: <%= effective_styles(:global)[:width] %>;
            height: auto;
            <%= map_style(effective_styles(:hero_image)) %>
          "
          class="g-img"
        >
      <% end %>
    <% end %>
    """
  end

  def h1(do: content) do
    ~E"""
      <h1 style="<%= map_style(effective_styles(:h1)) %>">
        <%= content %>
      </h1>
    """
  end

  def h2(do: content) do
    ~E"""
    <h2 style="<%= map_style(effective_styles(:h2)) %>">
      <%= content %>
    </h2>
    """
  end

  def p(do: content) do
    ~E"""
    <p style="<%= map_style(effective_styles(:body)) %>">
      <%= content %>
    </p>
    """
  end

  def styled_button(opts, do: content), do: button(opts, do: content)

  def button(opts, do: content) do
    {overrides, opts_without_style} = Keyword.pop(opts, :style, %{})
    {href, _rest_opts} = Keyword.pop!(opts_without_style, :href)

    style = effective_styles(:button, overrides)
    cell_style = style |> Map.take([:border_radius, :background])

    ~E"""
      <%= wrapper do %>
        <td
          class="button-td button-td-primary"
          style="<%= map_style(cell_style) %>"
        >
          <a
            class="button-a button-a-primary"
            href="<%= href %>"
            style="<%= map_style(style) %>"
          >
            <%= content %>
          </a>
        </td>
      <% end %>
    """
  end

  def ul(opts) do
    {items, _rest_opts} = Keyword.pop!(opts, :items)

    item_count = Enum.count(items)

    item_tags =
      items
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        li_for_ul(index, item_count, item)
      end)

    ~E"""
    <ul style="<%= map_style(effective_styles(:ul)) %>">
      <%= item_tags %>
    </ul>
    """
  end

  def footer do
    ~E"""
    <%= wrapper do %>
      <td style="<%= map_style(effective_styles(:footer)) %>">
        <%= Legendary.I18n.t! "en", "email.company.name" %><br>
        <span class="unstyle-auto-detected-links">
          <%= Legendary.I18n.t! "en", "email.company.address" %><br>
          <%= Legendary.I18n.t! "en", "email.company.phone" %>
        </span>
        <br><br>
      </td>
    <% end %>
    """
  end

  defp li_for_ul(index, list_length, content) do
    style_type = if index == list_length - 1, do: :last_li, else: :li

    ~E"""
      <li style="<%= map_style(effective_styles(style_type)) %>">
        <%= content %>
      </li>
    """
  end

  defp wrapper(do: content) do
    ~E"""
    <table align="center" role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin: auto;">
      <tr>
        <%= content %>
      </tr>
    </table>
    """
  end

  defp map_style(map) do
    map
    |> Enum.map(fn {key, value} ->
      new_key =
        key
        |> Atom.to_string()
        |> String.replace("_", "-")
      "#{new_key}: #{value};"
    end)
    |> Enum.join("\n")
  end
end
