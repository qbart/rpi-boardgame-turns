defmodule TimeUtils do
  def now() do
    NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
  end
end
