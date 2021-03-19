defmodule Legendary.AuthWeb.PowEmailConfirmation.MailerView do
  use Legendary.AuthWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
