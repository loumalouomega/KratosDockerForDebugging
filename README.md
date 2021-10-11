# KratosDockerForDebugging

[![License][license-image]][license] [![CI](https://github.com/loumalouomega/KratosDockerForDebugging/actions/workflows/ci.yml/badge.svg)](https://github.com/loumalouomega/KratosDockerForDebugging/actions/workflows/ci.yml)

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license]: https://github.com/loumalouomega/KratosDockerForDebugging/blob/main/LICENSE


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
