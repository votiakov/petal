defmodule CoreWeb.Helpers do
  @moduledoc """
  HTML helpers for our styled (Fomantic UI) forms.
  """
  use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 2]
  import CoreWeb.ErrorHelpers

  def has_role?(conn = %Plug.Conn{}, role) do
    conn
    |> Pow.Plug.current_user()
    |> Auth.Roles.has_role?(role)
  end

  def changeset_error_block(changeset) do
    ~E"""
    <%= if changeset.action do %>
      <div class="ui negative message">
        <p>Oops, something went wrong! Please check the errors below.</p>
      </div>
    <% end %>
    """
  end

  def flash_block(conn) do
    ~E"""
    <div class="fixed w-full z-50 mt-20">
      <%= [info: "grey", error: "red"] |> Enum.map(fn {level, color} ->  %>
        <%= if get_flash(conn, level) do %>
          <div class="relative bg-<%= color %>-100 p-5 w-1/2 object-right rounded shadow-xl m-auto mb-5 js-flash">
            <div class="flex justify-between text-<%= color %>-700">
              <div class="flex space-x-3">
                <div class="flex-1 leading-tight text-sm font-medium">
                  <%= get_flash(conn, level) %>
                </div>
              </div>
              <div class="flex-none js-flash-closer">
                &times;
              </div>
            </div>
          </div>
        <% end %>
      <% end) %>
    </div>
    """
  end

  def styled_input(f, field, opts \\ [], options \\ nil) do
    styled_input(f, field, opts, options) do
      ""
    end
  end

  def styled_input(f, field, opts, options, do: content) do
    {icon, rest_opts} = Keyword.pop(opts, :icon, "")
    {classes, rest_opts} = Keyword.pop(rest_opts, :class, "px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:shadow-outline w-full")
    {label_text, rest_opts} = Keyword.pop(rest_opts, :label)
    {input_helper, rest_opts} = Keyword.pop(rest_opts, :input_helper, :text_input)
    ~E"""
    <div class="relative w-full mb-3 <%= error_class(f, field) %>">
      <%= if label_text do %>
        <%= label f, field, label_text, class: "block uppercase text-gray-700 text-xs font-bold mb-2" %>
      <% else %>
        <%= label f, field, class: "block uppercase text-gray-700 text-xs font-bold mb-2" %>
      <% end %>

      <i class="<%= icon %> icon"></i>
      <%= if options == nil do %>
        <%= apply(Phoenix.HTML.Form, input_helper, [f, field, rest_opts ++ [class: classes]]) %>
      <% else %>
        <%= apply(Phoenix.HTML.Form, input_helper, [f, field, options, rest_opts ++ [class: classes]]) %>
      <% end %>
      <%= content %>

      <%= error_tag f, field, class: "ui pointing red basic label" %>
    </div>
    """
  end

  def pow_extension_enabled?(extension) do
    {extensions, _rest} = Application.get_env(:auth_web, :pow) |> Keyword.pop(:extensions, [])

    Enum.any?(extensions, & &1 == extension)
  end
end
