defmodule MementoWeb.ScoreLive.Show do
  use MementoWeb, :live_view

  alias Memento.HighScores

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:score, HighScores.get_score!(id))}
  end

  defp page_title(:show), do: "Show Score"
  defp page_title(:edit), do: "Edit Score"
end
