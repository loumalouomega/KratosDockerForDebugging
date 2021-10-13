# KratosDockerForDebugging

[![License][license-image]][license] [![CI](https://github.com/loumalouomega/KratosDockerForDebugging/actions/workflows/ci.yml/badge.svg)](https://github.com/loumalouomega/KratosDockerForDebugging/actions/workflows/ci.yml)

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license]: https://github.com/loumalouomega/KratosDockerForDebugging/blob/main/LICENSE

![](docs/kratos.png)

This is a docker file for generate a debugging VM. Uses VS Code server nor JupyterLab so the debugging is easier.

![](docs/vscodeserver.png)

# How to use

## Compile

### Compile without VS Code server nor JupyterLab

~~~sh
docker build -f ./docker/Dockerfile -t KratosTest .

~~~

### Compile with VS Code server

~~~sh
docker build -f ./docker/Dockerfile_with_VSCODE -t KratosTestVSCode .
~~~

### Compile with JupyterLab

~~~sh
docker build -f ./docker/Dockerfile_with_JupyterLab -t KratosTestJupyterLab .
~~~

## Download current image from Dockerhub

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/repository/docker/loumalouomega/kratos4debug/general)

### Without VS Code server nor JupyterLab

~~~sh
docker pull loumalouomega/kratos4debug:KratosTest
~~~

### With VS Code server

~~~sh
docker pull loumalouomega/kratos4debug:KratosTestVSCode
~~~

### With JupyterLab

~~~sh
docker pull loumalouomega/kratos4debug:KratosTestJupyterLab
~~~

## Run

### Without VS Code server nor JupyterLab

~~~sh
docker run -it loumalouomega/kratos4debug:KratosTest
~~~

### With VS Code server

~~~sh
docker run -p 8080:8080 --network="host" loumalouomega/kratos4debug:KratosTestVSCode
~~~

### With JupyterLab

~~~sh
docker run -p 8888:8888 --network="host" loumalouomega/kratos4debug:KratosTestJupyterLab
~~~

## VS Code Server

Once you have started the docker image with VS Code server you can acess to the instance going to [localhost:8080](http://127.0.0.1:8080).

## JupyterLab

Once you have started the docker image with JupyterLab you can acess to the instance going to [localhost:8888/lab](http://127.0.0.1:8888/lab).
