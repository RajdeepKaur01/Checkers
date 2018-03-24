defmodule CheckersWeb.Router do
  use CheckersWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :get_current_user
    plug :put_secure_browser_headers
  end

  def get_current_user(conn, _params) do
    # TODO: Move this function out of the router module.
    user_id = get_session(conn, :user_id)
    user = Checkers.Accounts.get_user(user_id || -1)
    IO.inspect(user)
    assign(conn, :current_user, user)
    IO.inspect(@current_user)
      assign(conn, :current_user, user)
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CheckersWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
   get "/game/:game", PageController, :game
   get "/game", PageController, :index1
   resources "/users", UserController
   post "/session", SessionController, :create
   delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", CheckersWeb do
  #   pipe_through :api
  # end
end
