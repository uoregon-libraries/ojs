# OJS Podman Setup

This directory contains configuration files for running the Open Journal Systems (OJS) in Podman containers. These files allow you to run OJS in a containerized environment while keeping the original repository intact.

## Files

- `Dockerfile` - Defines the application container with PHP, Apache, Node.js, and Composer
- `docker-compose.yml` - Orchestrates the application and database services
- `config.inc.php` - Customized OJS configuration for the containerized environment
- `setup.sh` - Helper script to manage the Podman containers

## Prerequisites

- [Podman](https://podman.io/) installed on your system
- [podman-compose](https://github.com/containers/podman-compose) installed (`pip3 install podman-compose`)

## Setup

Use the getting started guide provided by OJS: https://docs.pkp.sfu.ca/dev/documentation/en/getting-started

Here are a few caveats to know:
1. You need to run composer from the application shell (`./setup shell`) because it needs to run with PHP version 8.1 (even though the documentation says 8.x).
2. NPM should be able to be run from anywhere (so far it works fine from running form the host system).
3. You don't need to run their `php -S localhost:8000` command, since we're hosting from our containers and can access as stated below (in the start documentation).

## Usage

### Starting the Application

```bash
./setup.sh start
```

This will start both the application and database containers. The application will be available at http://localhost:8080.

### Stopping the Application

```bash
./setup.sh stop
```

### Rebuilding Containers

If you make changes to the Dockerfile or need to rebuild the containers:

```bash
./setup.sh build
```

### Viewing Logs

```bash
./setup.sh logs
```

### Accessing the Application Shell

```bash
./setup.sh shell
```

This gives you access to the application container's shell, where you can run Composer commands and other tools.

### Accessing the Database Shell

```bash
./setup.sh db-shell
```

This opens a MySQL shell connected to the database.

## Configuration

- The database is accessible on port 3307 (to avoid conflicts with local MySQL instances)
- Database credentials:
  - Username: `ojs`
  - Password: `ojs_password`
  - Database: `ojs`
- The application code is mounted as a volume, so changes to the code will be reflected immediately
- The configuration file sample is in the `adi` directory. You should copy the sample into the main directory and rename it `config.inc.php`.
  - Use the appropriate settings for your usecase, the sample is a good option for a local development environment.

## Troubleshooting

If you encounter issues with port conflicts, check if you have other services running on ports 8080 or 3307. You can modify the port mappings in the `docker-compose.yml` file if needed.

## File Storage

OJS stores uploaded files in a persistent Podman volume named `ojs_files`. This volume:
- Persists independently of container rebuilds
- Is mounted at `/var/www/html/files` in the container
- Is not part of the git repository
- Maintains proper permissions for OJS to read/write files

### Backing Up Files

To backup the files volume:
```bash
podman volume export ojs_files > ojs_files_backup.tar
```

To restore from a backup:
```bash
podman volume import ojs_files < ojs_files_backup.tar
```

### Important Notes
- The files volume persists even when containers are rebuilt
- Files are only lost if you explicitly remove the volume or run `podman system prune --volumes`
- Regular backups are recommended for important data

## Container Management

- Start containers: `./setup.sh start`
- Stop containers: `./setup.sh stop`
- Rebuild containers: `./setup.sh build`
- View logs: `./setup.sh logs`
- Check status: `./setup.sh status` 