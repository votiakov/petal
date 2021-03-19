defmodule Legendary.AuthWeb.Pow.MailerTest do
  use ExUnit.Case
  use Bamboo.Test

  import Legendary.AuthWeb.Pow.Mailer

  alias Legendary.Auth.User

  def hello_email do
    cast(%{
      user: %User{email: "test@example.org"},
      subject: "Hello, email",
      text: "This is a hello email.",
      html: "<h1>Hello!</h1>",
    })
  end

  test "cast/1" do
    email = hello_email()
    assert %{to: "test@example.org"} = email
    assert email.text_body =~ "This is a hello email."
    assert email.html_body =~ "<h1>Hello!</h1>"
  end

  test "process/1" do
    email = hello_email()

    process(email)

    assert_delivered_email email
  end
end
