defmodule TwitterWeb.Live.Component.Header do
  use TwitterWeb, :live_component

  def render(assigns) do
    ~L"""
      <header class="header">
        <div>
          <%= @inner_content.(uuid: @uuid, changeset: @changeset, parent: @myself) %>
        </div>
      </header>
    """
  end

  def mount(socket) do
    {:ok, initial_state(socket)}
  end

  def handle_event("search", %{"form" => %{"code" => code}}, socket) do
    send(self(), {:search, %{code: code}})

    {:noreply, initial_state(socket)}
  end

  defp initial_state(socket) do
    assign(socket, uuid: Ecto.UUID.generate(), changeset: Twitter.Form.changeset(%Twitter.Form{}, %{}))
  end
end
