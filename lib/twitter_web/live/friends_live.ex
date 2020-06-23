defmodule TwitterWeb.FriendsLive do
  use TwitterWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
      Hello
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("search", %{"code" => query}, socket) do
    {:noreply, socket}
  end
end
