# Football
[![Build Status](https://travis-ci.org/mememori/football.svg?branch=master)](https://travis-ci.org/mememori/football)[![Ebert](https://ebertapp.io/github/mememori/football.svg)](https://ebertapp.io/github/mememori/football)

## Compile the application
This is step is needed before executing any of the other actions (start server, test, document, ...)

### On Docker
Build the image using the following command
```bash
sudo docker-compose -f "automation/docker/docker-compose.yml" build
```

### Directly
If you don't want to use Docker, ensure that PostgreSQL is running then execute:
```bash
mix do deps.get, compile, ecto.create, ecto.migrate
```

## Start the server

### On Docker
```bash
sudo docker-compose -f "automation/docker/docker-compose.yml" up
```

### Directly
```bash
mix phx.server
```

## Test the codebase

### On docker
```bash
sudo docker exec docker_football_1 mix test
```

### Directly
```bash
mix test
```
