defmodule MementoWeb.MemorizeLive do
  use MementoWeb, :live_view
  alias Memento.Game.{Eraser, Form}
  
  def mount(_params, _session, socket) do
    text = "Four score and seven years ago"
    steps = 5
    
    {
      :ok, 
      assign(
        socket, 
        eraser: nil, 
        changeset: Form.change(%Form{}, %{}))
    }
  end
  
  def render(assigns) do
    ~L"""
    <%= if @eraser do %>
    <h1>Memorize this: </h1>
    <p><%= @eraser.text %></p>
    <button phx-click="erase" <%= btn_disabled?(Eraser.done?(@eraser)) %>>Erase it!</button>
    <% else %>
    <h1>What do you want to memorize?</h1>
    
    <%= f = form_for @changeset, "#",
      phx_change: "validate",
      phx_submit: "save" %>

      <%= label f, :text %>
      <%= text_input f, :text %>
      <%= error_tag f, :text %>

      <%= label f, :steps %>
      <%= text_input f, :steps %>
      <%= error_tag f, :steps %>

      <%= submit "Memorize!", phx_disable_with: "Saving..." %>
    </form>
    <% end %>
    """
  end
  
  defp btn_disabled?(true), do: "disabled"
  defp btn_disabled?(_false), do: ""
  
  defp erase(socket) do
    assign(socket, eraser: Eraser.next_step(socket.assigns.eraser))
  end
  
  defp validate(socket, params) do
    assign(
      socket, 
      changeset: Form.change(%Form{}, params))
  end
  
  defp save(socket, params) do
    assign(
      socket, 
      eraser: Eraser.new(params["text"], String.to_integer(params["steps"])))
  end
  
  def handle_event("erase", _, socket) do
    {:noreply, erase(socket)}
  end
  
  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, validate(socket, params)}
  end
  
  def handle_event("save", %{"form" => params}, socket) do
    {:noreply, save(socket, params)}
  end

end