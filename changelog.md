# Changelog

## 0.4.0 (dev)

* Lotka Volterra simulation

## 0.3.2

* extract Game of Life as separate sub application, with its own supervision tree.

* refactor realm to a more robust architecture

  * Sim.Realm.Data: holds the data and broadcasts changes to PubSub. This part is the most robust one, the data will still be available even if the server and the simulation loop crash.

  * Sim.Realm.SimulationLoop: Has a recurring tick when the simulation is running. This will trigger the realm server to block all incoming request during simulation.

  * Sim.Realm.Server: All incoming request are going through this server. It also executes the sim funtions in a separate task.

  * There are two Supervisors, one to monitor the data and the simulation loop, the other monitors the server with its task supervisor.

* use macros to customize Sim.Realm context and server functions.

## 0.3.1

* various upgrades

  * Elixir 1.10.3

  * Phoenix 1.5.1

  * Phoenix Live View 0.13.3 (including new adaptions)

  * Phoenix PubSub 2.0

  * cypress 4.5.0

* include Phoenix Live Dashboard (dev only)

* improve pipeline by storing test containers for further steps

* split Dockerfile for pipline into test and release

* add credo to pipeline

* remove cypress from devDependencies


## 0.3.0

* new application ```sim```

* Sim.Grid a 2 dimensional map

* Sim.Torus a grid with no borders

* abstraction of RealmSupervisor, Realm, SimulationLoop

* Game of Life live view

* Add Line-Awesome font

* extract common view logic to ```view_helper.ex```

* Add Logger to context, simulation loop and realm

## 0.2.1

* Use Nginx as server service (not as docker container)
  with Letsencrypt (not as docker container)

* Counter example, with realm, root, context, simulation modules

* CSS variables to define colors

* Fix separate set current_user and check for member area

* Fix clear input field after sending chat message

* Update to Phoenix Live View 0.2.1

## 0.2.0

* Chat with Live View

* Store chat messages in GenServer

* integration tests with cypress.io

* new environment `integration` for CI

* new docker compose for integrtion on CI

* replace Bugsnag with Sentry

## 0.1.0

* Runs as Docker container

* Releases with Elixir 1.9

* CI/CD with Semaphore 2

* Assets via Parcel

* Bugsnag integration

* Authentication with Github account

* Authorization with Canada and Canary

* Phoenix Live View
