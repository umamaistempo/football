# Football
[![Build Status](https://travis-ci.org/mememori/football.svg?branch=master)](https://travis-ci.org/mememori/football)[![Coverage Status](https://coveralls.io/repos/github/mememori/football/badge.svg?branch=master)](https://coveralls.io/github/mememori/football?branch=master)[![Ebert](https://ebertapp.io/github/mememori/football.svg)](https://ebertapp.io/github/mememori/football)

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
Note that starting the project on docker will start three instances of the server and a loadbalancer.
```bash
sudo docker-compose -f "automation/docker/docker-compose.yml" up
```

Access the server through `http://localhost/api/leagues`

### Directly
```bash
mix phx.server
```

Access the server through `http://localhost:4000/api/leagues`

## Test the codebase

### On docker
```bash
sudo docker exec docker_football_1 mix test
```

### Directly
```bash
mix test
```

## Generate documentation
This command will generate the application documentation on the application `/doc` folder.

### On docker
TODO

### Directly
```bash
mix docs
```

## Project considerations

### Load balancing
In this project I have specified the same service (`football`) three times to show load balancing with HAProxy without the need of more than one node or the use of an automation tool like Ansible.

If this was an application for the real world, it would have a single instance of the `football` container deployed accross several nodes and with the network data fed to the HAProxy node allowing it to balance load between them.
