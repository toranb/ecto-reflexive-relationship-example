defmodule TwitterWeb.Live.Component.Invite do
  use TwitterWeb, :live_component

  def render(assigns) do
    ~L"""
      <div>
        <span><%= @friend.name %></span>
        <button style="background-color: green; border: 0.1rem solid green;" phx-target=<%= @myself %> phx-click="accept" phx-value=<%= @friend.id %>>Accept</button>
      </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def handle_event("accept", _value, %{assigns: %{friend: friend}} = socket) do
    send(self(), {:accept, %{user_id: friend.id}})

    {:noreply, socket}
  end
end
