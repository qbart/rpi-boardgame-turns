defmodule BalloonboardWeb.Archive.SessionView do
  use BalloonboardWeb, :view
  use Timex

  def format_datetime(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> Timezone.convert("Europe/Warsaw")
    |> Timex.format!("%H:%M:%S", :strftime)
  end

  def diff_datetime(start, stop) do
    start = DateTime.from_naive!(start, "Etc/UTC")
    stop = DateTime.from_naive!(stop, "Etc/UTC")

    DateTime.diff(stop, start, :second)
    |> BalloonboardWeb.SessionView.format_duration()
  end
end
