# KratosDockerForDebugging
This is a docker file for generate a debugging VM.

Uses VS Code server so the debugging is easier

# Compile

~~~sh
docker build -f ./Dockerfile -t kratos_test . 
~~~

# Run

~~~sh
docker run -p 8080:8080 --network="host" kratos_test 
~~~
