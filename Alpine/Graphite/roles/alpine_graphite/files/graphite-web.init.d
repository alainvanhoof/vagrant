#!/sbin/openrc-run

USER=root
GROUP=root
SERVICE="graphite-web"
COMMAND="/usr/bin/gunicorn"
CMD_ARGS=${GRAPHITEWEB_OPTS}
CMD_ENV="${GRAPHITEWEB_ENV}"
DIR="/opt/graphite"

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