defmodule TwitterWeb.SearchLive do
  use TwitterWeb, :live_view

  alias Twitter.Repo
  alias Twitter.User
  alias Twitter.Friendship
  alias TwitterWeb.Live.Component.Friend
  alias TwitterWeb.Live.Component.Input
  alias TwitterWeb.Live.Component.Header

  import Ecto.Query, warn: false

  @impl true
  def render(assigns) do
    ~L"""
      <h2>Search</h2>
      <div>
        <%= live_component @socket, Header, id: 1 do %>
          <%= f = form_for @changeset, "#", [phx_target: @parent, phx_submit: :search, autocomplete: "off", autocorrect: "off", autocapitalize: "off", spellcheck: "false"] %>
            <%= live_component(@socket, Input, id: @uuid, form: f, field: :code) %>
            <%= submit "submit", [class: "d-none"] %>
          </form>
        <% end %>
      </div>
      <div>
        <%= for friend <- assigns.friends do %>
          <%= live_component(@socket, Friend, id: friend.id, friend: friend) %>
        <% end %>
      </div>
    """
  end

  @impl true
  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    {:ok, assign(socket, current_user_id: current_user_id, friends: [])}
  end

  @impl true
  def handle_info({:invite, %{user_id: user_id}}, %{assigns: %{current_user_id: current_user_id}} = socket) do
    friend = User |> Repo.get(user_id)
    current_user_id = current_user_id |> String.to_integer()

    %Friendship{
      user_id: current_user_id,
      friend_id: friend.id,
      status_id: "PENDING"
    }
    |> Repo.insert!()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:search, %{code: code}}, socket) do
    friends =
      from(u in User,
        where: u.code == ^code
      )
      |> Repo.all()

    {:noreply, assign(socket, friends: friends)}
  end
end
