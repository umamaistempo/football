defmodule FootballWeb.Router do
  use FootballWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", FootballWeb, as: :api do
    pipe_through(:api)

    scope "/leagues" do
      get("/", LeagueController, :index, as: :league)
      get("/:code", LeagueController, :show, as: :league)
    end
  end
end
