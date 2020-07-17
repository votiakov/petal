defmodule AuthWeb.PowResetPassword.MailerView do
  use AuthWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
