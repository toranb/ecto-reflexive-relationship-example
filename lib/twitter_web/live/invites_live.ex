defmodule TwitterWeb.InvitesLive do
  use TwitterWeb, :live_view

  alias Twitter.Repo
  alias Twitter.User
  alias Twitter.Friendship
  alias TwitterWeb.Live.Component.Invite

  import Ecto.Query, warn: false

  @impl true
  def render(assigns) do
    ~L"""
      <h2>Invites</h2>

      <%= for friend <- assigns.invites do %>
        <%= live_component(@socket, Invite, id: friend.id, friend: friend) %>
      <% end %>
    """
  end

  @impl true
  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    status_id = "PENDING"

    invites =
      from(f in Friendship,
        where: f.friend_id == ^current_user_id and f.status_id == ^status_id,
        preload: [:user]
      )
      |> Repo.all()
      |> Enum.map(fn fr -> fr.user end)

    {:ok, assign(socket, current_user_id: current_user_id, invites: invites)}
  end

  @impl true
  def handle_info({:accept, %{user_id: user_id}}, %{assigns: %{current_user_id: current_user_id}} = socket) do
    friend = User |> Repo.get(user_id)

    status_id = "PENDING"

    friendship =
      from(f in Friendship,
        where: f.user_id ==^friend.id and f.friend_id == ^current_user_id and f.status_id == ^status_id
      )
      |> Repo.one!()

    friendship
    |> Friendship.changeset(%{
      status_id: "ACCEPTED"
    })
    |> Repo.insert_or_update()

    {:noreply, socket}
  end
end
