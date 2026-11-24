#!/bin/bash
# Pruebas en modo CLI (no GUI). Requiere JMeter 5.6.x en el PATH.
# Uso: ./run_tests.sh [host] [port]
HOST=${1:-localhost}; PORT=${2:-80}
export HEAP="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"
for N in 10 100 1000 5000; do
  rm -rf report_$N
  jmeter -n -t TestPlan.jmx -Jhost=$HOST -Jport=$PORT -Jthreads=$N -Jrampup=10 -Jloops=1 \
         -l result/resultado_$N.jtl -e -o report_$N
done
