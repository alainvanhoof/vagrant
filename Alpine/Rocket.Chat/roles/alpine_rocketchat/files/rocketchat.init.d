#!/sbin/openrc-run

USER=rocketchat
GROUP=rocketchat
SERVICE="rocketchat"
COMMAND="/usr/bin/node"
CMD_ARGS=${ROCKETCHAT_OPTS}
CMD_ENV="${ROCKETCHAT_ENV}"
DIR="/opt/rocketchat/bundle"

depend() {
    need net
    need localmount
}

start() {
    ebegin "Starting ${SERVICE}"
    start-stop-daemon --background --start \
    --make-pidfile --pidfile /run/${SERVICE}.pid \
    --exec ${CMD_ENV} ${COMMAND} \
    --user ${USER:-root} \
    --group ${GROUP:-root} \
    --chdir ${DIR} \
    -- ${CMD_ARGS}
    eend $?
}

stop() {
    ebegin "Stopping ${SERVICE}"
    start-stop-daemon --stop --exec ${COMMAND} \
    --pidfile /run/${SERVICE}.pid
    eend $?
}