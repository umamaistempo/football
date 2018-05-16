defmodule Football.Repo do
  use Ecto.Repo, otp_app: :football

  def init(_, opts) do
    username = System.get_env("FOOTBALL_DATABASE_USERNAME") || opts[:username] || "postgres"
    password = System.get_env("FOOTBALL_DATABASE_PASSWORD") || opts[:password] || "postgres"
    hostname = System.get_env("FOOTBALL_DATABASE_HOSTNAME") || opts[:hostname] || "localhost"

    opts =
      opts
      |> Keyword.put(:url, System.get_env("FOOTBALL_DATABASE_URL"))
      |> Keyword.put(:username, username)
      |> Keyword.put(:password, password)
      |> Keyword.put(:hostname, hostname)

    {:ok, opts}
  end
end
