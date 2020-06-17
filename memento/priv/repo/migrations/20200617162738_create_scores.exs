defmodule Memento.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :score, :integer
      add :initials, :string

      timestamps()
    end

  end
end
