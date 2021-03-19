defmodule Legendary.AuthWeb.PowResetPassword.MailerView do
  use Legendary.AuthWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
