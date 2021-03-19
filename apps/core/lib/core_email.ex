defmodule Legendary.CoreEmail do
  @moduledoc """
  The core library for email in the application. The functions here can be composed in the application to send
  different emails.
  """
  import Bamboo.Email
  use Bamboo.Phoenix, view: Legendary.CoreWeb.CoreEmailView

  def base_email() do
    new_email()
    |> put_html_layout({Legendary.CoreWeb.CoreEmailView, "email.html"})
    |> put_text_layout({Legendary.CoreWeb.CoreEmailView, "email.text"})
    |> from(sender())
  end

  defp sender() do
    Application.get_env(:core, :email_from)
  end
end
