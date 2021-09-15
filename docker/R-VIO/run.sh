# Run the docker image with access to X display on host system

#PGM_DEFAULT=terminator
PGM_DEFAULT=bash
PGM=${1:-$PGM_DEFAULT}

#https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIRNAME/../config.sh"
NAME=$(basename $DIRNAME)
NAME_LOWER=$(echo "${NAME}" | tr '[:upper:]' '[:lower:]')
# allow any user to access the X server for graphical output
xhost local:
# add default ros uri if not set
ROS_MASTER_URI="${ROS_MASTER_URI:-http://172.17.0.1:11311/}"
# start ros core if not started
roslaunch --core 1>/dev/null 2>/dev/null &
docker run -it --rm \
    --name="$NAME_LOWER" \
    -h "$NAME_LOWER" \
    -e "DISPLAY=$DISPLAY" \
    -e ROS_MASTER_URI="${ROS_MASTER_URI}" \
    -e "ROS_HOSTNAME=$(hostname)" \
    -e "ROS_IP=192.168.0.59" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "/home/kent/catkin_wses/R-VIO:/opt/R-VIO" \
    --net=host \
    "vodocker/$NAME_LOWER" $PGM
