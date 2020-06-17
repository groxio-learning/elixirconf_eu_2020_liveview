defmodule MementoWeb.ScoreLive.FormComponent do
  use MementoWeb, :live_component

  alias Memento.HighScores

  @impl true
  def update(%{score: score} = assigns, socket) do
    changeset = HighScores.change_score(score)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"score" => score_params}, socket) do
    changeset =
      socket.assigns.score
      |> HighScores.change_score(score_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"score" => score_params}, socket) do
    save_score(socket, socket.assigns.action, score_params)
  end

  defp save_score(socket, :edit, score_params) do
    case HighScores.update_score(socket.assigns.score, score_params) do
      {:ok, _score} ->
        {:noreply,
         socket
         |> put_flash(:info, "Score updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_score(socket, :new, score_params) do
    case HighScores.create_score(score_params) do
      {:ok, _score} ->
        {:noreply,
         socket
         |> put_flash(:info, "Score created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
