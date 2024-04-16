#!/bin/bash
# Function to start docker service, check its status, and execute docker compose with given profile
export HOST_IP=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

#Working Directory
current_dir=$(pwd)
COMPOSE_FILE="./appliance/compose.yml"

start_docker_compose() {
    if [ "$PROFILE" = "redhat" ] || [ "$PROFILE" = "suse" ]; then

      container_ids=$(docker compose --file "$COMPOSE_FILE" ps --services "$PROFILE-ansible" -q )
      if [ ! "$container_ids" ]; then
	 echo ""
         echo "Executing 'docker compose --file $COMPOSE_FILE --profile $PROFILE up -d'..."
         docker compose --file $COMPOSE_FILE --profile $PROFILE up -d

	 sleep 3
	 container_ids=$(docker compose --file "$COMPOSE_FILE" ps --services "$PROFILE-ansible" -q )
         if [ ! "$container_ids" ]; then
          echo "Failed to start Docker Compose $PROFILE services. Exiting."
          return 1
         fi

         echo "Docker Compose $PROFILE services have been started."
         echo ""

      else
         echo "Docker Compose $PROFILE services already running...."
         fi
    else
       echo "Invalid argument. Usage: appliance start [redhat|suse]"
       return 2
    fi
    return 0
}

stop_docker_compose() {
    if [ "$PROFILE" = "redhat" ] || [ "$PROFILE" = "suse" ]; then
         #Check Docker Compose Service
         container_ids=$(docker compose --file "$COMPOSE_FILE" ps --services "$PROFILE-ansible" -q )

         if [ "$container_ids" ]; then
            read -p "Are you sure you want to stop Docker Compose services for $PROFILE ? (y/n) " choice
	    case "$choice" in
                y|Y )
                   echo "Stopping $PROFILE Docker Compose services..."
	           docker compose --file $COMPOSE_FILE --profile $PROFILE down
                   echo ""
                   echo "Docker Compose $PROFILE services have been stopped..."
               ;;
               n|N )
                 echo "Stop operation cancelled."
                 return  # Exit the function
               ;;
               * )
                 echo "Invalid input"
               ;;
            esac
	 else
             echo "Docker Compose $PROFILE services not running...."
	     return 1
           fi
       else
           echo "Invalid argument. Usage: appliance stop [redhat|suse]"
	   return 2
       fi
       return 0
}

connect_docker_compose() {
    if [ "$PROFILE" = "redhat" ] || [ "$PROFILE" = "suse" ]; then
	#Check Docker Compose Service
        container_ids=$(docker compose --file "$COMPOSE_FILE" ps --services "$PROFILE-ansible" -q )

        if [ "$container_ids" ]; then
           case "$PROFILE" in
               "redhat")
                   echo "Connecting Redhat Docker Compose services..."
                   docker exec -it ansible-redhat /bin/bash
                   ;;
               "suse")
                   echo "Connecting Suse Docker Compose services..."
                   docker exec -it ansible-suse /bin/bash
                   ;;
           esac
        else
             echo "Docker Compose $PROFILE services not running...."
	     return 1
           fi
    else
        echo "Invalid argument. Usage: appliance connect [redhat|suse]"
	return 2
    fi
    return 0
}


display_help() {
    echo "Usage: compose-lnx.sh action [redhat|suse]"
    echo "action:"
    echo "    start   Start Docker Compose Services For the Given Profile."
    echo "    stop    Stop Docker Compose Services For the Given Profile."
    echo "    connect Connect Docker Compose Services For the Given Profile."
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
        "help")
            display_help
            ;;
        *)
            echo "Invalid action..."
            echo ""
            display_help
            ;;
    esac
elif [ $# -eq 0 ]; then
    echo "Missing arguments."
    display_help
else
    echo "Invalid action..."
    echo ""
    display_help
fi
