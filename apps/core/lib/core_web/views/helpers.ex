defmodule Legendary.CoreWeb.Helpers do
  @moduledoc """
  HTML helpers for our styled (Tailwind) forms.
  """
  use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 2]
  import Legendary.CoreWeb.ErrorHelpers

  defdelegate current_user(a), to: Legendary.AuthWeb.Helpers
  defdelegate has_role?(a, b), to: Legendary.AuthWeb.Helpers

  def changeset_error_block(changeset) do
    ~E"""
    <%= if changeset.action do %>
      <div class="flex-auto px-4 lg:px-10 py-6 text-red-500 text-center">
        <p>Oops, something went wrong! Please check the errors below.</p>
      </div>
    <% end %>
    """
  end

  def flash_block(conn) do
    ~E"""
    <div class="fixed w-full px-4 z-50 mt-20">
      <%= [info: "green", error: "red"] |> Enum.map(fn {level, color} ->  %>
        <%= if get_flash(conn, level) do %>
          <div class="relative bg-<%= color %>-100 lg:w-1/2 w-full p-5 object-right rounded shadow-xl m-auto mb-5 js-flash">
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

  def styled_input(f, field, opts \\ [], options \\ nil, block_list \\ []) do
    {content, _} = Keyword.pop(block_list, :do, "")
    {type, rest_opts} = Keyword.pop(opts, :type, input_type(f, field))
    {classes, rest_opts} = Keyword.pop(rest_opts, :class, default_classes_for_type(type))
    {label_text, rest_opts} = Keyword.pop(rest_opts, :label)
    {input_helper, _rest_opts} = Keyword.pop(rest_opts, :input_helper, input_type(f, field))

    error_classes =
      if Keyword.get_values(f.errors, field) |> Enum.any?() do
        " border border-red-500"
      else
        ""
      end

    ~E"""
    <div class="relative w-full mb-3 <%= error_class(f, field) %>">
      <%= if label_text do %>
        <%= label f, field, label_text, class: "block uppercase text-gray-700 text-xs font-bold mb-2" %>
      <% else %>
        <%= label f, field, class: "block uppercase text-gray-700 text-xs font-bold mb-2" %>
      <% end %>

      <%= do_styled_input_tag(type, input_helper, f, field, options, opts, classes, error_classes) %>
      <%= content %>

      <%= error_tag f, field, class: "text-red-500 italic" %>
    </div>
    """
  end

  defp do_styled_input_tag(type, input_helper, f, field, nil, opts, classes, error_classes) when type in [:date_select, :time_select, :datetime_select] do
    default_child_opts = [
      month: [
        class: "appearance-none border-b-2 border-dashed",
        options: [
          {("Jan"), "1"},
          {("Feb"), "2"},
          {("Mar"), "3"},
          {("Apr"), "4"},
          {("May"), "5"},
          {("Jun"), "6"},
          {("Jul"), "7"},
          {("Aug"), "8"},
          {("Sep"), "9"},
          {("Oct"), "10"},
          {("Nov"), "11"},
          {("Dec"), "12"},
        ]
      ],
      day: [class: "appearance-none border-b-2 border-dashed"],
      year: [class: "appearance-none border-b-2 border-dashed"],
      hour: [class: "appearance-none border-b-2 border-dashed"],
      minute: [class: "appearance-none border-b-2 border-dashed"],
      second: [class: "appearance-none border-b-2 border-dashed"],
    ]

    {child_opts, rest_opts} = Keyword.pop(opts, :child_opts, default_child_opts)

    ~E"""
      <%= content_tag :div, class: Enum.join([classes, error_classes], " ") do %>
        <%= apply(Phoenix.HTML.Form, input_helper, [f, field, rest_opts ++ child_opts]) %>
      <% end %>
    """
  end

  defp do_styled_input_tag(_type, input_helper, f, field, nil, opts, classes, error_classes) do
    apply(Phoenix.HTML.Form, input_helper, [f, field, opts ++ [class: Enum.join([classes, error_classes], " ")]])
  end

  defp do_styled_input_tag(_type, input_helper, f, field, options, opts, classes, error_classes) do
    apply(Phoenix.HTML.Form, input_helper, [f, field, options, opts ++ [class: Enum.join([classes, error_classes], " ")]])
  end

  defp default_classes_for_type(type) when type in [:date_select, :time_select, :datetime_select] do
    "bg-white shadow rounded p-3"
  end
  defp default_classes_for_type(:checkbox), do: "appearance-none h-10 w-10 bg-white checked:bg-gray-500 rounded shadow focus:outline-none focus:shadow-outline text-white text-xl font-bold mb-2"
  defp default_classes_for_type(_), do: "px-4 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:shadow-outline w-full"

  def styled_button(text) do
    ~E"""
    <%= submit text, class: "bg-gray-900 text-white active:bg-gray-700 text-sm font-bold uppercase px-4 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 w-full" %>
    """
  end

  def styled_button_link(text, opts) do
    ~E"""
    <%= link text, opts ++ [class: "bg-gray-900 text-white active:bg-gray-700 text-sm font-bold uppercase px-4 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 w-full"] %>
    """
  end

  def paginator(first..last, current, callback) do
    [first, current - 1, current, current + 1, last]
    |> Enum.sort()
    |> Enum.filter(& &1 >= first)
    |> Enum.filter(& &1 <= last)
    |> Enum.dedup()
    |> Enum.map(& callback.(first..last, &1))
  end

  def group_rounding_class(first..last, current, [first_class, middle_class, last_class] \\ ["rounded-l", "", "rounded-r"]) do
    cond do
      first == last -> "#{first_class} #{last_class}"
      current == first -> first_class
      current == last -> last_class
      true -> middle_class
    end
  end

  @spec floating_form(any, atom | %{action: any}, [{:do, any}, ...]) :: {:safe, [...]}
  def floating_form(title, changeset, do: content) do
    ~E"""
    <h1 class="relative text-white text-xl font-semibold text-center pb-6"><%= title %></h1>
    <div
      class="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-lg rounded-lg bg-gray-300 border-0"
    >
      <%= changeset_error_block(changeset) %>
      <div class="flex-auto px-4 lg:px-10 pt-6 pb-10">
        <%= content %>
      </div>
    </div>
    """

  end

  def floating_page_wrapper(do: content) do
    ~E"""
    <section class="absolute w-full h-full">
      <div class="absolute top-0 w-full h-full bg-gray-700"></div>
      <div class="container mx-auto px-4 h-full">
        <div class="flex content-center items-center justify-center h-full">
          <div class="w-full lg:w-4/12 px-4">
            <%= content %>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def pow_extension_enabled?(extension) do
    {extensions, _rest} = Application.get_env(:core, :pow) |> Keyword.pop(:extensions, [])

    Enum.any?(extensions, & &1 == extension)
  end
end
