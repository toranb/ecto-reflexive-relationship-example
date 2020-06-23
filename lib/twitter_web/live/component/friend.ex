defmodule TwitterWeb.Live.Component.Friend do
  use TwitterWeb, :live_component

  def render(assigns) do
    ~L"""
      <div>
        <span><%= @friend.name %></span>
        <button phx-target=<%= @myself %> phx-click="invite" phx-value=<%= @friend.id %>>invite</button>
      </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def handle_event("invite", _value, %{assigns: %{friend: friend}} = socket) do
    send(self(), {:invite, %{user_id: friend.id}})

    {:noreply, socket}
  end
end
