# gastronovi controller docker image and composing
This project needs at least docker 20.10.7 because it uses the new buildin `docker compose` command. It should run on arm and x86 platforms as long as an adoptopenjdk build is available for the intended platform.


## Using the Docker Composing
### Start
To start the composing use the following command.

```bash
docker compose --project-name gnc up --detach --build --remove-orphans
```

The container will always restart after failing due to:
- failure while downloading gastronovi-controller
- termination by forced update via the web interface (which always fails with status code 0)
- restart of the docker host

### Stop
To stop use the following command 

```bash
docker compose --project-name gnc down
```
### Logs
Getting logs

```bash
docker compose --project-name gnc logs -t -f
```

## Update gastronovi controller
Since there is no semantic versioning the container always fetches the newest version available from gastronovi on start. This behavior can be exploited to update to the newest version of the controller. Just restart the container. Beware, other components like the JVM or the OS are not updated on restart for this you can append ```--pull``` to the ```docker compose up``` command.

There are several ways to restart the container.

### manually via web interface
 One ist to access the web interface and hit the **search update button**. This will try download a newer (and even the same version), tries to restarts which got caught by docker which in turn restarts the whole container.

### manually via docker
You can always restart manually by following command in the project directory:

```bash
docker compose --project-name gnc restart
```

It is also possible to restart the container directly without using the compose project and its project name:

```bash
docker restart gnc_gastronovi-controller_1
```

### automatically with a cronjob
This could be used in a cronjob to restart this specific container

```
30 4 * * * docker restart gnc_gastronovi-controller_1 >> /var/log/gastronovi_cronjob.log 2>&1
```

This restarts the container everyday at 04:30 am