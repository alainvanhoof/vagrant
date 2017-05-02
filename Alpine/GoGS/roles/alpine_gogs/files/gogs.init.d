#!/sbin/openrc-run

DIR=/opt/gogs/src/github.com/gogits/gogs
PORT=3000
USER=root

start_stop_daemon_args="--user ${USER} --chdir ${DIR}"
command="${DIR}/gogs"
command_args="web -port ${PORT}"
command_background=yes
pidfile=/var/run/gogs.pid

depend()
{
    need net
}