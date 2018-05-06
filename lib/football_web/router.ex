defmodule FootballWeb.Router do
  use FootballWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", FootballWeb do
    pipe_through(:api)

    scope "/leagues" do
      get("/", LeagueController, :index)
      get("/:code", LeagueController, :show)
    end
  end
end
