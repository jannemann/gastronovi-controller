#!/usr/bin/env bash
echo "welcome to gastronovi-controller"
echo "os platform: $(arch)"
echo "os name: $(grep -E '^(NAME)=' /etc/os-release | cut -d '"' -f 2)"
echo "os version: $(grep -E '^(VERSION)=' /etc/os-release | cut -d '"' -f 2)"
echo "os kernel: $(uname -a)"
echo "java version: $(java -version 2>&1 | grep version | cut -d '"' -f 2)"
echo "user: $(whoami)"

GN_CONTROLLER_URL="https://office.gastronovi.de/gn_server.jar"
GN_CONTROLLER_FILENAME="gn_server.jar"

echo "download gastronovi controller"
if curl --silent --show-error --fail "${GN_CONTROLLER_URL}" --output "${GN_CONTROLLER_FILENAME}"; then
  echo "download was successful"
else
  status="$?"
  echo "download failed, exit code: ${status}"
  exit ${status}
fi

handleSignals() {
  local SIGNAL="SIGTERM"
  echo "sending ${SIGNAL} to ${PID}"
  kill -s "${SIGNAL}" "${PID}"
  wait "${PID}"
  local status="$?"
  echo "stopped ${PID} gracefully, exit code: ${status}"
  exit "${status}"
}
trap handleSignals SIGINT SIGTERM SIGHUP

java "${JAVA_OPTS}" -jar "${GN_CONTROLLER_FILENAME}" &
PID="$!"
echo "started gastronovi-controller with PID ${PID}"
wait "${PID}"

status="$?"
echo "gastronovi-controller with PID ${PID} stopped unexpected, exit code: ${status}"
exit "${status}"