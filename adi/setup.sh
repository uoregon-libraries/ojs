#!/bin/bash

# Function to display help message
show_help() {
    echo "OJS Podman Setup Script"
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start       - Start the OJS application"
    echo "  stop        - Stop the OJS application"
    echo "  restart     - Restart the OJS application"
    echo "  build       - Rebuild the containers"
    echo "  logs        - Show container logs"
    echo "  shell       - Open a shell in the app container"
    echo "  db-shell    - Open a shell in the database container"
    echo "  help        - Show this help message"
}

# Function to check if podman compose is installed
check_podman_compose() {
    if ! command -v podman compose &> /dev/null; then
        echo "Error: podman compose is not installed"
        echo "Please install it using: pip3 install podman-compose"
        exit 1
    fi
}

# Main script
check_podman_compose

case "$1" in
    start)
        podman compose -f docker-compose.yml up -d
        echo "OJS application started"
        ;;
    stop)
        podman compose -f docker-compose.yml down
        echo "OJS application stopped"
        ;;
    restart)
        podman compose -f docker-compose.yml restart
        echo "OJS application restarted"
        ;;
    build)
        podman compose -f docker-compose.yml build --no-cache
        echo "Containers rebuilt"
        ;;
    logs)
        podman compose -f docker-compose.yml logs -f
        ;;
    shell)
        podman compose -f docker-compose.yml exec app /bin/bash
        ;;
    db-shell)
        podman compose -f docker-compose.yml exec db mysql -u ojs -pojs_password ojs
        ;;
    help|*)
        show_help
        ;;
esac 