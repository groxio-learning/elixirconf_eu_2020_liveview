defmodule Memento.Game.Eraser do
  defstruct schedule: [], text: ""
  @dont_erase [",", ".", "\n"]
  
  
  def new(text, steps) do
    schedule = 
      1..String.length(text) 
      |> Enum.shuffle
      |> Enum.chunk_every(step_size(text, steps))
      
    %__MODULE__{schedule: schedule, text: text}
  end
  
  def next_step(%{text: text, schedule: [current|rest]}) do
    %__MODULE__{text: erase(text, current), schedule: rest}
  end
  
  defp erase(string, current) do
    string
    |> String.graphemes
    |> Enum.with_index(1)
    |> Enum.map(fn {char, index} -> 
      erase_char(char, index, current)
    end)
    |> Enum.join("")
  end
  
  defp erase_char(char, _i, _c) when char in @dont_erase, do: char
  defp erase_char(char, index, current) do 
    if index in current do
      "_"
    else
      char
    end
  end
  
  defp step_size(text, steps) do
    size = String.length(text)
    size
    |> Kernel./(steps)
    |> ceil
  end
end