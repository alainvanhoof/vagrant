#!/sbin/openrc-run

USER=root
SERVICE="grafana"
COMMAND="/opt/grafana/src/github.com/grafana/grafana/bin/grafana-server"
CMD_ARGS=${GRAFANA_OPTS}
DIR="/opt/grafana/src/github.com/grafana/grafana"

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