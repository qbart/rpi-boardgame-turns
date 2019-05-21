defmodule BalloonboardWeb.SessionView do
  use BalloonboardWeb, :view

  defp badge_class(true), do: "badge-success"
  defp badge_class(false), do: "badge-warning"

  def format_duration(duration) do
    m = div(duration, 60) |> Integer.to_string() |> String.pad_leading(2, "0")
    s = rem(duration, 60) |> Integer.to_string() |> String.pad_leading(2, "0")
    "#{m}:#{s}"
  end

  def avatar_url(avatar) do
    avatar
    |> String.replace("file://", "/images/avatars")
  end
end
