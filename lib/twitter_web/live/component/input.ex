defmodule TwitterWeb.Live.Component.Input do
  use TwitterWeb, :live_component

  import Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
      <%= text_input @form, @field, [placeholder: "buddy code", autofocus: true] %>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
