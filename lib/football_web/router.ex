defmodule FootballWeb.Router do
  use FootballWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FootballWeb do
    pipe_through :api
  end
end
