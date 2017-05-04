#!/sbin/openrc-run

USER=root
SERVICE="carbon-cache"
COMMAND="/opt/graphite/bin/carbon-cache.py"
CMD_ARGS=${CARBONCACHE_OPTS}
DIR="/opt/graphite"

depend() {
    need net
    need localmount
}

start() {
    ebegin "Starting ${SERVICE}"
    start-stop-daemon --background --start \
    --make-pidfile --pidfile /run/${SERVICE}.pid \
    --exec ${COMMAND} \
    --user ${USER:-root} \
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