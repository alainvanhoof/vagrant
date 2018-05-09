#!/sbin/openrc-run

USER=root
GROUP=root
SERVICE="kapacitor"
COMMAND="/opt/kapacitord"
CMD_ARGS="${KAPACITOR_OPTS}"

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
    --group ${GROUP:-root} \
    -- ${CMD_ARGS} >>/dev/null 2>>/var/log/kapacitor.log
    eend $?
}

stop() {
    ebegin "Stopping ${SERVICE}"
    start-stop-daemon --stop --exec ${COMMAND} \
    --pidfile /run/${SERVICE}.pid
    eend $?
}
