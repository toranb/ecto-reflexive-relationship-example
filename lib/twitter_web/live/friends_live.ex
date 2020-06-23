defmodule TwitterWeb.FriendsLive do
  use TwitterWeb, :live_view

  alias Twitter.Repo
  alias Twitter.User
  alias Twitter.Friendship
  alias TwitterWeb.Live.Component.Two

  import Ecto.Query, warn: false

  @impl true
  def render(assigns) do
    ~L"""
      <h2>Buddies</h2>

      <%= for friend <- assigns.friends do %>
        <%= live_component(@socket, Two, id: friend.id, friend: friend) %>
      <% end %>
    """
  end

  @impl true
  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    status_id = "ACCEPTED"

    friends =
      from(f in Friendship,
        where: f.user_id == ^current_user_id and f.status_id == ^status_id,
        preload: [:friend]
      )
      |> Repo.all()
      |> Enum.map(fn fr -> fr.friend end)

    {:ok, assign(socket, current_user_id: current_user_id, friends: friends)}
  end
end
