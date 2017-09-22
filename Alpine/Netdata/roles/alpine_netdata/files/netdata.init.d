#!/sbin/openrc-run

USER=root
GROUP=root
SERVICE="netdata"
COMMAND="/usr/sbin/netdata"
CMD_ARGS="${NETDATA_OPTS}"
DIR="/"

depend() {
    need net
    need localmount
}

start() {
    ebegin "Starting ${SERVICE}"
    echo 1 >/sys/kernel/mm/ksm/run
    echo 1000 >/sys/kernel/mm/ksm/sleep_millisecs
    start-stop-daemon --background --start \
    --make-pidfile --pidfile /run/${SERVICE}.pid \
    --exec ${COMMAND} \
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