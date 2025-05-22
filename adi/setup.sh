#!/bin/bash

# Default environment
ENV="dev"

# Function to display help message
show_help() {
    echo "OJS Podman Setup Script"
    echo "Usage: $0 [command] [environment]"
    echo ""
    echo "Commands:"
    echo "  start       - Start the OJS application"
    echo "  stop        - Stop the OJS application"
    echo "  restart     - Restart the OJS application"
    echo "  build       - Rebuild the containers"
    echo "  rebuild     - Stop, rebuild, and start the application"
    echo "  logs        - Show container logs"
    echo "  shell       - Open a shell in the app container"
    echo "  db-shell    - Open a shell in the database container (dev only)"
    echo "  help        - Show this help message"
    echo ""
    echo "Environments:"
    echo "  dev         - Development environment with local database (default)"
    echo "  prod        - Production environment without database"
    echo "  staging     - Staging environment without database"
}

# Function to check if podman compose is installed
check_podman_compose() {
    if ! command -v podman compose &> /dev/null; then
        echo "Error: podman compose is not installed"
        echo "Please install it using: pip3 install podman-compose"
        exit 1
    fi
}

# Function to get compose file based on environment
get_compose_file() {
    case "$ENV" in
        prod)
            echo "docker-compose.prod.yml"
            ;;
        staging)
            echo "docker-compose.staging.yml"
            ;;
        dev|*)
            echo "docker-compose.yml"
            ;;
    esac
}

# Function to check if command is allowed in environment
check_command_allowed() {
    local cmd=$1
    if [[ "$ENV" != "dev" && "$cmd" == "db-shell" ]]; then
        echo "Error: db-shell command is only available in development environment"
        exit 1
    fi
}

# Main script
check_podman_compose

# Set environment if provided
if [[ "$2" == "prod" || "$2" == "staging" ]]; then
    ENV="$2"
fi

COMPOSE_FILE=$(get_compose_file)

case "$1" in
    start)
        podman compose -f $COMPOSE_FILE up -d
        echo "OJS application started in $ENV environment"
        ;;
    stop)
        podman compose -f $COMPOSE_FILE down
        echo "OJS application stopped in $ENV environment"
        ;;
    restart)
        podman compose -f $COMPOSE_FILE restart
        echo "OJS application restarted in $ENV environment"
        ;;
    build)
        podman compose -f $COMPOSE_FILE build --no-cache
        echo "Containers rebuilt for $ENV environment"
        ;;
    rebuild)
        echo "Stopping containers..."
        podman compose -f $COMPOSE_FILE down
        echo "Rebuilding containers..."
        podman compose -f $COMPOSE_FILE build --no-cache
        echo "Starting containers..."
        podman compose -f $COMPOSE_FILE up -d
        echo "OJS application rebuilt and started in $ENV environment"
        ;;
    logs)
        podman compose -f $COMPOSE_FILE logs -f
        ;;
    shell)
        podman compose -f $COMPOSE_FILE exec app /bin/bash
        ;;
    db-shell)
        check_command_allowed "db-shell"
        podman compose -f $COMPOSE_FILE exec db mysql -u ojs -pojs_password ojs
        ;;
    help|*)
        show_help
        ;;
esac 