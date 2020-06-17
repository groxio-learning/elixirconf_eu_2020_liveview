defmodule MementoWeb.MemorizeLive do
  use MementoWeb, :live_view
  
  def mount(_params, _session, socket) do
    {:ok, assign(socket, hello: :world, count: 0)}
  end
  
  def render(assigns) do
    ~L"""
    <h1>Hello, <%= @hello %></h1>
    <h2 phx-click="count">Count them up, <%= @count %></h2>
    """
  end
  
  defp count(socket) do
    assign(socket, count: socket.assigns.count + 1)
  end
  
  def handle_event("count", _, socket) do
    {:noreply, count(socket)}
  end
end
