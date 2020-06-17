defmodule Memento.Game.Form do
  defstruct [:text, :steps]
  @types %{text: :string, steps: :integer}
  
  def change(form, params) do
    {form, @types}
    |> Ecto.Changeset.cast(params, Map.keys(@types))
    |> Ecto.Changeset.validate_required(~w[text steps]a)
    |> Ecto.Changeset.validate_length(:text, min: 3)
    |> Map.put(:action, :validate)
  end
end


# -------------
# user = %User{}
# types = %{first_name: :string, last_name: :string, email: :string}
# changeset =
#   {user, types}
#   |> Ecto.Changeset.cast(params, Map.keys(types))
#   |> Ecto.Changeset.validate_required(...)
#   |> Ecto.Changeset.validate_length(...)