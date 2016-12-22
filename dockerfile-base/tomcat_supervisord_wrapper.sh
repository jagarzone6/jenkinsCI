#!/bin/bash
# Source: https://confluence.atlassian.com/plugins/viewsource/viewpagesrc.action?pageId=252348917
function shutdown()
{
    date
    echo "Shutting down Tomcat"
    #unset CATALINA_PID # Necessary in some cases
    #unset JAVA_OPTS # Necessary in some cases

    /opt/tomcat/bin/catalina.sh stop
}

date
echo "Starting Tomcat"
#export CATALINA_PID=/tmp/$$
#export JAVA_HOME=/usr/lib/jvm/java-7-oracle/
# export JAVA_OPTS="-Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.password.file=/etc/tomcat.jmx.pwd -Dcom.sun.management.jmxremote.access.file=/etc/tomcat.jmxremote.access -Dcom.sun.management.jmxremote.ssl=false -Xms128m -Xmx3072m -XX:MaxPermSize=256m"

# Uncomment to increase Tomcat's maximum heap allocation
# export JAVA_OPTS=-Xmx512M $JAVA_OPTS
export JAVA_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,address=1317,suspend=n,server=y
export JAVA_OPTS=-Xms4048m -Xmx5096m  $JAVA_OPTS
export JAVA_OPTS=-Djava.awt.headless=true -DJENKINS_HOME=/data/jenkins  $JAVA_OPTS
export CATALINA_OPTS=-XX:PermSize=4048m -XX:MaxPermSize=5096m -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -javaagent:/opt/tomcat/newrelic/newrelic.jar

. /opt/tomcat/bin/catalina.sh start

# Allow any signal which would kill a process to stop Tomcat
trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

echo "Waiting for `cat $CATALINA_PID`"
wait `cat $CATALINA_PID`

