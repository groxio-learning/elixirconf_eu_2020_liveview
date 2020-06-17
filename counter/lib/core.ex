defmodule Counter.Core do
  def new(value \\ 42) do
    value
  end
  
  def inc(count) do
    count + 1
  end
  
  def dec(count) do
    count - 1
  end
end