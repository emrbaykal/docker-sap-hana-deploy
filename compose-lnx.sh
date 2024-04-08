#!/bin/bash
# Function to start docker service, check its status, and execute docker compose with given profile
# Export Host IP
export HOST_IP=$(hostname -I | awk '{print $1}')

#Working Directory
current_dir=$(pwd)

start_docker_compose() {
    echo "Starting Docker service..."
    sudo systemctl start docker

    echo "Starting nfs service..."
    sudo systemctl start nfs-kernel-server

    if [ $(sudo systemctl is-active docker) = "active" ] && [ $(sudo systemctl is-active nfs-kernel-server) = "active" ]; then
       if [ "$1" = "redhat" ] || [ "$1" = "suse" ]; then
           echo "Docker & nfs-kernel-server services are running..."
	   echo ""
           echo "Executing 'docker compose --file $current_dir/ansible/compose.yml --profile $1 up -d'..."
           docker compose --file $current_dir/ansible/compose.yml --profile $1 up -d
           echo "Docker Compose $1 services have been started."
           echo ""
           show_docker_compose_status
	   echo ""
       else
           echo "Invalid argument. Usage: appliance start [redhat|suse]"
       fi
    else 
        if [ $(sudo systemctl is-active docker) = "inactive" ]; then
	  echo ""
          echo "Docker service is not running. Please check the service status."
	fi
	if [ $(sudo systemctl is-active nfs-kernel-server) = "inactive" ]; then
          echo ""
          echo "nfs-kernel-server service is not running. Please check the service status."
        fi
    fi
}

stop_docker_compose() {
    if [ "$1" = "redhat" ] || [ "$1" = "suse" ]; then
           echo "Stopping $1 Docker Compose services..."
           docker compose --file $current_dir/ansible/compose.yml --profile $1 down
	   echo ""
           echo "Docker Compose $1 services have been stopped..."
	   sudo systemctl stop nfs-kernel-server
           echo "nfs-kernel-server service has been stopped..."
    else
        echo "Invalid argument. Usage: appliance stop [redhat|suse]"
    fi
}

connect_docker_compose() {
    if [ "$1" = "redhat" ] || [ "$1" = "suse" ]; then
        case "$1" in
            "redhat")
                echo "Connecting Redhat Docker Compose services..."
                docker exec -it ansible-rhel /bin/bash
                ;;
            "suse")
                echo "Connecting Suse Docker Compose services..."
                docker exec -it ansible-sles /bin/bash
                ;;
        esac
    else
        echo "Invalid argument. Usage: appliance connect [redhat|suse]"
    fi
}

# Function to show Docker Compose status
show_docker_compose_status() {
    echo "Docker Compose Service Status..."
    docker compose --file $current_dir/ansible/compose.yml ps
}

display_help() {
    echo "Usage: appliance action [redhat|suse]"
    echo "action:"
    echo "    start   Start Docker Compose Services For the Given Profile."
    echo "    stop    Stop Docker Compose Services For the Given Profile."
    echo "    connect Connect Docker Compose Services For the Given Profile."
    echo "    status  Show Docker Compose Status."
    echo "    help    Display Help Message."
    echo "profile:"
    echo "    redhat  Start/Stop Docker Redhat Compose services."
    echo "    suse    Start/Stop Docker Suse Compose services."
}

# Check if a specific function is provided as a command line argument
if [ $# -eq 2 ]; then
    ACTION=$1
    PROFILE=$2

    case "$ACTION" in
        "start")
            start_docker_compose $PROFILE
            ;;
        "stop")
            stop_docker_compose $PROFILE
            ;;
	"connect")
            connect_docker_compose $PROFILE
            ;;
        *)
            echo "Invalid action..."
	    echo ""
	    display_help
            ;;
    esac
elif [ $# -eq 1 ]; then
    ACTION=$1

    case "$ACTION" in
        "status")
            show_docker_compose_status
            ;;
        "help")
            display_help
            ;;
        *)
            echo "Invalid action..."
            echo ""
            display_help
            ;;
    esac
else
    echo "Invalid action..."
    echo ""
    display_help
fi
