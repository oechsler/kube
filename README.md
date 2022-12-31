# kube
📜 Kubernetes development template

This repo contains a service template for developing Kubernetes enabled microservices.
It furthermore allowes the development of the service fully within a live Kubernetes cluster.
Included is a pre-configured Golang service, which serves a minimal webservice.
This can be used as a startingpoint, or replaced by whatever technology stack that should be used to develop the microservice.

## Getting started

A few prerequisites are needed to get started with this template.
First of all you need a Kubernetes cluster to which the service template can be deployed.
For local deployment and development [minikube](https://minikube.sigs.k8s.io/docs/) is the recommended choice.
In addition to that an installation of the Make build-management-tool and the  [okteto](https://www.okteto.com/docs/getting-started/) toolchain is required.

Once cloned, first build the production Docker image for the service.

```sh
make build
```

This not only builds the image but also pushes it to the local image registry on minikube.  
If you want to deploy the image to a live cluster insted, modifications to the `Makefile` have to be made first.

Next, initialize the service.

```sh
make init
```

This spins up an instance of the service as if it was deployed in production.
It consists of a Kubernetes Namespace, a Deployment of the application and a Service exposing the ports of the Deployment within the Kuberntes cluster.

At last the service can be switched into development mode.

```sh
make dev
```

This halts the production version of the service and spins up the okteto local development environment.
The development environment is based on the image used to build the service and allowes you to start a SSH session into it.
With that you can attach various remote development tools and IDEs to the container.
A configuration for Visual Studio Code comes pre-configured.

Further information on the other available Make targets is provided through the `make help` command.

&minus; Enjoy!

Copyright &copy; 2022 **Samuel Oechsler**

