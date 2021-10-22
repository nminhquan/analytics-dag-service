#!/bin/sh
echo "Docker test"
dagit -h 0.0.0.0 -p 8121 -f repo.py &
dagster-daemon run