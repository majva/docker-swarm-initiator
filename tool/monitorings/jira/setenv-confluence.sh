# See the CATALINA_OPTS below for tuning the JVM arguments used to start Confluence.

echo "If you encounter issues starting up Confluence, please see the Installation guide at http://confluence.atlassian.com/display/DOC/Confluence+Installation+Guide"

# set the location of the pid file
if [ -z "$CATALINA_PID" ] ; then
    if [ -n "$CATALINA_BASE" ] ; then
        CATALINA_PID="$CATALINA_BASE"/work/catalina.pid
    elif [ -n "$CATALINA_HOME" ] ; then
        CATALINA_PID="$CATALINA_HOME"/work/catalina.pid
    fi
fi
export CATALINA_PID

PRGDIR=`dirname "$0"`
if [ -z "$CATALINA_BASE" ]; then
  if [ -z "$CATALINA_HOME" ]; then
    LOGBASE=$PRGDIR
    LOGTAIL=..
  else
    LOGBASE=$CATALINA_HOME
    LOGTAIL=.
  fi
else
  LOGBASE=$CATALINA_BASE
  LOGTAIL=.
fi

PUSHED_DIR=`pwd`
cd $LOGBASE
cd $LOGTAIL
LOGBASEABS=`pwd`
cd $PUSHED_DIR

echo ""
echo "Server startup logs are located in $LOGBASEABS/logs/catalina.out"
# IMPORTANT NOTE: Only set JAVA_HOME or JRE_HOME above this line
# Get standard Java environment variables
if $os400; then
  # -r will Only work on the os400 if the files are:
  # 1. owned by the user
  # 2. owned by the PRIMARY group of the user
  # this will not work if the user belongs in secondary groups
  . "$CATALINA_HOME"/bin/setjre.sh
else
  if [ -r "$CATALINA_HOME"/bin/setjre.sh ]; then
    . "$CATALINA_HOME"/bin/setjre.sh
  else
    echo "Cannot find $CATALINA_HOME/bin/setjre.sh"
    echo "This file is needed to run this program"
    exit 1
  fi
fi

echo "---------------------------------------------------------------------------"
echo "Using Java: $JRE_HOME/bin/java"
CONFLUENCE_CONTEXT_PATH=`$JRE_HOME/bin/java -jar $CATALINA_HOME/bin/confluence-context-path-extractor.jar $CATALINA_HOME`
export CONFLUENCE_CONTEXT_PATH
$JRE_HOME/bin/java -jar $CATALINA_HOME/bin/synchrony-proxy-watchdog.jar $CATALINA_HOME
echo "---------------------------------------------------------------------------"

# Set the JVM arguments used to start Confluence.
# For a description of the vm options of jdk 8, see:
# http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html
# For a description of the vm options of jdk 11, see:
# https://docs.oracle.com/en/java/javase/11/tools/java.html
CATALINA_OPTS="-XX:+IgnoreUnrecognizedVMOptions ${CATALINA_OPTS}"
CATALINA_OPTS="-XX:-PrintGCDetails -XX:+PrintGCDateStamps -XX:-PrintTenuringDistribution ${CATALINA_OPTS}"
CATALINA_OPTS="-Xlog:gc+age=debug:file=$LOGBASEABS/logs/gc-`date +%F_%H-%M-%S`.log::filecount=5,filesize=2M ${CATALINA_OPTS}"
CATALINA_OPTS="-Xloggc:$LOGBASEABS/logs/gc-`date +%F_%H-%M-%S`.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=2M ${CATALINA_OPTS}"
CATALINA_OPTS="-XX:G1ReservePercent=20 ${CATALINA_OPTS}"
CATALINA_OPTS="-Djava.awt.headless=true ${CATALINA_OPTS}"
CATALINA_OPTS="-Datlassian.plugins.enable.wait=300 ${CATALINA_OPTS}"
CATALINA_OPTS="-Xms${JVM_MINIMUM_MEMORY:=1024m} -Xmx${JVM_MAXIMUM_MEMORY:=1024m} -Dconfluence.home=${CONFLUENCE_HOME} -XX:+UseG1GC ${CATALINA_OPTS}"
CATALINA_OPTS="-Dsynchrony.enable.xhr.fallback=true ${CATALINA_OPTS}"
CATALINA_OPTS="-Dorg.apache.tomcat.websocket.DEFAULT_BUFFER_SIZE=32768 ${CATALINA_OPTS}"
CATALINA_OPTS="-Djava.locale.providers=JRE,SPI,CLDR ${CATALINA_OPTS}"
CATALINA_OPTS="${START_CONFLUENCE_JAVA_OPTS} ${CATALINA_OPTS}"
CATALINA_OPTS="-Dconfluence.context.path=${CONFLUENCE_CONTEXT_PATH} ${CATALINA_OPTS}"
CATALINA_OPTS="-Djdk.tls.server.protocols=TLSv1.1,TLSv1.2 -Djdk.tls.client.protocols=TLSv1.1,TLSv1.2 ${CATALINA_OPTS}"
CATALINA_OPTS="-XX:ReservedCodeCacheSize=${JVM_RESERVED_CODE_CACHE_SIZE:=256m} -XX:+UseCodeCacheFlushing ${CATALINA_OPTS}"


CATALINA_OPTS="${CATALINA_OPTS} ${JVM_SUPPORT_RECOMMENDED_ARGS} -DConfluenceHomeLogAppender.disabled=${CONFLUENCE_LOG_STDOUT}"

export CATALINA_OPTS

export JAVA_OPTS="-javaagent:/opt/atlassian/confluence/atlassian-agent.jar ${JAVA_OPTS}"

