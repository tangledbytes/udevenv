#!/bin/sh

container_name=udevenv
image_name=utkarsh23/udevenv:latest

function build() {
	docker build -t $image_name .
}

function start() {
	if [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "running" ]; then
		echo "Container $container_name is already running. Run ./udevenv.sh stop to stop it."
	else
		local cmd="docker run"
		cmd="$cmd --name ${container_name}"
		cmd="$cmd --tty -d --privileged --init=false --user root"
		cmd="$cmd --security-opt seccomp=unconfined --security-opt apparmor=unconfined"
		cmd="$cmd --tmpfs /tmp --tmpfs /run"
		cmd="$cmd --hostname $USER-devenv"
		cmd="$cmd -e KIND_EXPERIMENTAL_CONTAINERD_SNAPSHOTTER -e USERNAME=$USER -e USERPASS=$USERPASS"
		cmd="$cmd $@"
		cmd="$cmd ${image_name}"

		$cmd
	fi
}

function stop() {
	if [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "running" ]; then
		docker stop ${container_name}
	else
		echo "Container $container_name is not running. Run ./udevenv.sh start to start it."
	fi
}

function shell() {
	if [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "running" ]; then
		docker exec -it -u $USER -w /home/$USER ${container_name} /bin/zsh
	else
		echo "Container $container_name is not running. Run ./udevenv.sh start to start it."
	fi
}

function clean() {
	if [ "$( docker container inspect -f '{{.State.Status}}' $container_name )" == "running" ]; then
		echo "Container $container_name is running. Run ./udevenv.sh stop to stop it."
	else
		docker rm ${container_name}
	fi
}

function logs() {
	docker logs -f ${container_name}
}

function help() {
	echo "Usage: ./udevenv.sh [build|start|stop|shell|clean|logs|help]"
}

case "$1" in
	build)
		shift;
		build $@
		;;
	start)
		shift;
		start $@
		;;
	stop)
		shift;
		stop $@
		;;
	shell)
		shift;
		shell $@
		;;
	clean)
		shift;
		clean $@
		;;
	logs)
		shift;
		logs $@
		;;
	help)
		shift;
		help $@
		;;
	*)
		help $@
		;;
esac