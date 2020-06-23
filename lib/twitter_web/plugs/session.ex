defmodule TwitterWeb.Plug.Session do
  import Plug.Conn, only: [get_session: 2, put_session: 3, halt: 1, assign: 3]
  import Phoenix.Controller, only: [redirect: 2]

  def redirect_unauthorized(conn, _opts) do
    user_id = Map.get(conn.assigns, :user_id)

    if user_id == nil do
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: TwitterWeb.Router.Helpers.login_path(conn, :index))
      |> halt()
    else
      conn
    end
  end

  def validate_session(conn, _opts) do
    case :ets.lookup(:twitter_auth_table, :user_id) do
      [] ->
        conn

      [{_, user_id}] ->
        conn
        |> assign(:user_id, user_id)
        |> put_session("current_user_id", user_id)
    end
  end
end
