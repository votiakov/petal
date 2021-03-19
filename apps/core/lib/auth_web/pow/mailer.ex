defmodule Legendary.AuthWeb.Pow.Mailer do
  @moduledoc """
  Mailer module for Pow which links it to our well-styled defaults.
  """
  use Pow.Phoenix.Mailer

  import Bamboo.Email
  use Bamboo.Phoenix, view: Legendary.AuthWeb.EmailView

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    Legendary.CoreEmail.base_email()
    |> to(user.email)
    |> subject(subject)
    |> render(:pow_mail, html_body: html, text_body: text)
  end

  @impl true
  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.

    Legendary.CoreMailer.deliver_later(email)
  end
end
