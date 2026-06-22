#!/bin/bash

ENVIRONMENT=$1
PORT=$2

echo "Running health check for $ENVIRONMENT environment on port $PORT..."

sleep 5

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT)

if [ "$STATUS" -eq 200 ]; then
    echo "✅ $ENVIRONMENT is healthy! HTTP $STATUS"
    exit 0
else
    echo "❌ $ENVIRONMENT health check failed! HTTP $STATUS"
    exit 1
fi

