defmodule ThundermoonWeb.AuthController do
  use ThundermoonWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  alias ThundermoonWeb.AuthService

  def request(conn, _params) do
    render(conn, "login.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Authentification failed!")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case AuthService.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated as #{user.username}.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end
end
