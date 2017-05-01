#!/sbin/openrc-run

SRVC="jenkins"             
                           
pid_file="/run/${SRVC}.pid"                                                        
                                                                                   
ARGS="-Dfile.encoding=UTF-8 -Djava.awt.headless=true -jar /opt/jenkins/jenkins.war"
                
depend() {      
        need net
}        
                                 
start() {                                                                                    
        ebegin "Starting Jenkins"                                                            
        start-stop-daemon --background --start --quiet --pidfile ${pid_file} --make-pidfile \
                --chdir /opt/jenkins \
                --exec /usr/bin/java \
                -- ${ARGS}
        eend $?
 
}       
                                 
stop() {                                              
        ebegin "Stopping Jenkins"                     
        start-stop-daemon --stop --pidfile ${pid_file}
        eend $?
}