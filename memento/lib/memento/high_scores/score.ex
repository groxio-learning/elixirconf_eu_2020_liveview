defmodule Memento.HighScores.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :initials, :string
    field :score, :integer

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:score, :initials])
    |> validate_required([:score, :initials])
  end
end
