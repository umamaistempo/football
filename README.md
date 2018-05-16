# Football
[![Build Status](https://travis-ci.org/mememori/football.svg?branch=master)](https://travis-ci.org/mememori/football)[![Coverage Status](https://coveralls.io/repos/github/mememori/football/badge.svg?branch=master)](https://coveralls.io/github/mememori/football?branch=master)[![Inline docs](http://inch-ci.org/github/mememori/football.svg?branch=master)](http://inch-ci.org/github/mememori/football)[![Ebert](https://ebertapp.io/github/mememori/football.svg)](https://ebertapp.io/github/mememori/football)

## Compiling the application
This step is needed before executing any of the other actions (start server, test, document, ...)

### On Docker
Build the image using the following command
```bash
sudo docker-compose -f "automation/docker/docker-compose.yml" build
```

### Directly
If you don't want to use Docker, ensure that PostgreSQL is running then execute:
```bash
mix do deps.get, ecto.setup
```

## Starting the server
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

## Testing the codebase
### On docker
```bash
sudo docker exec docker_football_1 mix test
```

### Directly
```bash
mix test
```

## Generating documentation
This command will generate the application documentation on the application `/doc` folder.

### On docker
TODO

### Directly
```bash
mix docs
```

## Project considerations
### Load balancing
In this project, the same service (`football`) was specified three times to show load balancing with HAProxy without the need of more than one node or the use of an automation tool like Ansible.

If this was an application for the real world, it would have only a single definition of the `football` container to be deployed across several nodes and with the network data fed to the HAProxy node allowing it to balance load between them.

### Database use
Since this project provides only a read-only RESTful API, it didn't need a database (data could be loaded from a file and kept in-memory), but a database was used to make it easier to include more data, provide more resource endpoints and to allow filtering data in the future.

## License
This source code is released under GPL 3.

Check [LICENSE](LICENSE) or [GNU GPL3](https://www.gnu.org/licenses/gpl-3.0.en.html)
for more information.

[![GPL3](https://www.gnu.org/graphics/gplv3-88x31.png)](https://www.gnu.org/licenses/gpl-3.0.en.html)
