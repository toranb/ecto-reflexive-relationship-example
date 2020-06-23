defmodule TwitterWeb.LoginLive do
  use TwitterWeb, :live_view

  import Phoenix.HTML.Form

  import TwitterWeb.Live.Helper,
    only: [
      showing_error: 3,
      aria_hidden: 3,
      detail_error: 3,
      inline_error: 3,
      submit_value: 2,
      is_disabled: 1
    ]

  alias Twitter.Login

  alias TwitterWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~L"""
    <aside class="opacity-80 hidden bg-no-repeat bg-cover bg-top h-screen w-0 md:fixed lg:fixed lg:w-1/3 lg:bg-scroll lg:block lg:top-0 lg:left-0" role="note" style="background-image: url(<%= Routes.static_path(TwitterWeb.Endpoint, "/images/signup.jpg") %>)"></aside>
    <main class="h-screen pt-8 w-auto lg:ml-33pt">
      <div class="flex items-center w-full md:max-w-md md:mx-auto">
        <div class="w-full p-2 m-4">
          <%= form_for @changeset, "#", [phx_change: :validate, phx_submit: :save, class: 'mb-4 md:flex md:flex-wrap md:justify-between', autocomplete: "off", autocorrect: "off", autocapitalize: "off", spellcheck: "false"], fn f -> %>
            <fieldset class="flex flex-col md:w-full" <%= is_disabled(@changeset) %>>
              <div class="text-center mb-5 pb-5"><div class="logo m-auto font-medium"></div></div>
              <div class="flex flex-col md:w-full">
                <div class="flex flex-col <%= showing_error(f, @changeset, :name) %> md:w-full fx relative">
                  <%= text_input f, :name, [class: "#{inline_error(f, @changeset, :name)} focus:border focus:border-b-0 rounded border text-grey-darkest", placeholder: "Enter your name", aria_describedby: "form_name_detail", aria_required: "true", phx_blur: :blur_name] %>
                  <label class="text-gray-500" for="form_name">Name</label>
                </div>
                <div aria-live="polite" aria-hidden="<%= aria_hidden(f, @changeset, :name) %>" id="form_name_detail" class="<%= detail_error(f, @changeset, :name) %> detail bg-shop-info pt-2 pb-2 pl-5 pr-4 rounded rounded-t-none relative block border-t-0 border">
                  <span aria-hidden="<%= aria_hidden(f, @changeset, :name) %>" class="text-left text-sm text-shop-black">Name Required</span>
                </div>
              </div>

              <%= hidden_input f, :name_touched %>
              <%= hidden_input f, :form_submitted %>
              <%= hidden_input f, :form_disabled %>

              <%= submit submit_value(@changeset, "Login"), [class: "w-full text-white bg-shop-green uppercase font-bold text-lg p-2 rounded"] %>
            </fieldset>
          <% end %>
        </div>
      </div>
    </main>
    """
  end

  @impl true
  def mount(_params, _, socket) do
    changeset =
      Login.Form.changeset(%Login.Form{}, %{})
      |> Map.put(:action, :insert)

    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    if Map.get(params, "form_disabled", nil) != "true" do
      changeset =
        Login.Form.changeset(%Login.Form{}, params)
        |> Ecto.Changeset.put_change(:form_submitted, true)
        |> Ecto.Changeset.put_change(:form_disabled, true)
        |> Map.put(:action, :insert)

      send(self(), {:disable_form, changeset})

      {:noreply, assign(socket, changeset: changeset)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    changeset = Login.Form.changeset(%Login.Form{}, params) |> Map.put(:action, :insert)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("blur_name", _value, socket) do
    blur_event("name", socket)
  end

  def blur_event(field, %{assigns: %{:changeset => changeset}} = socket) do
    changeset =
      changeset
      |> Ecto.Changeset.put_change(:"#{field}_touched", true)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_info({:disable_form, changeset}, socket) do
    name = Ecto.Changeset.get_field(changeset, :name)

    case Twitter.Repo.get_by(Twitter.User, name: name) do
      %Twitter.User{id: user_id} ->
        :ets.insert(:twitter_auth_table, {:user_id, "#{user_id}"})

        path = Routes.page_path(socket, :index)
        redirect = socket |> redirect(to: path)

        {:noreply, redirect}

      changeset ->
        changeset =
          changeset
          |> Ecto.Changeset.put_change(:form_disabled, false)

        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
