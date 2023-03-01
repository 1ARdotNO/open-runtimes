#!/bin/sh

# Build runtime Docker image
cd runtimes/${RUNTIME}
docker build -t open-runtimes/test-runtime .

# Enter function folder
cd ../../
cd tests/resources/functions/${RUNTIME}

# Prevent Docker mount from creating directory
touch code.tar.gz

# Build and start runtime
docker run --rm --name open-runtimes-test-build -v $(pwd):/mnt/code:rw -e OPEN_RUNTIMES_ENTRYPOINT=${ENTRYPOINT} open-runtimes/test-runtime sh -c "sh helpers/build.sh 'npm install'"
docker run --rm -d --name open-runtimes-test-serve -v $(pwd)/code.tar.gz:/mnt/code/code.tar.gz:rw -e OPEN_RUNTIMES_SECRET=test-secret-key -e CUSTOM_ENV_VAR=customValue -p 3000:3000 open-runtimes/test-runtime sh -c "sh helpers/start.sh 'npm start'"

# Wait for runtime to start
echo "Waiting for servers..."
sleep 10

# Run tests
cd ../../../../
echo "Running tests..."
OPEN_RUNTIMES_SECRET=test-secret-key OPEN_RUNTIMES_ENTRYPOINT=${ENTRYPOINT} vendor/bin/phpunit --configuration phpunit.xml tests/${PHP_CLASS}.php
