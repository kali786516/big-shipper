#!/bin/bash

if ! type sbt &> /dev/null; then
	echo "Install SBT"
	exit 1
fi

sparkVer=$(spark-shell --version 2>&1 | awk '{if($0 ~ /version [0-9\.]+$/ && match($0,/[0-9]\.[0-9]\.[0-9]/,v)){print v[0]}}')
if (( $(echo "${sparkVer%.*} < 2.0" | bc -l) )); then
	echo "Tests not working in Spark version below 2.0."
	exit 1
fi

if ! grep -q "spark-testing-base" build.sbt;then
	echo "libraryDependencies += \"org.scalatest\" %% \"scalatest\" % \"3.0.1\" % \"test\"" >> build.sbt
	echo "libraryDependencies += \"com.holdenkarau\" %% \"spark-testing-base\" % \"${sparkVer}_0.6.0\"" >> build.sbt
fi

sbt test
