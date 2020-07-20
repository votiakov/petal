defmodule Content.Scheduler do
  @moduledoc """
    The Quantum cron-like scheduler for this application. See config.exs for
    configured jobs.
  """

  use Quantum.Scheduler,
    otp_app: :content
end
