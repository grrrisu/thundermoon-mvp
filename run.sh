#!/bin/sh
set -e

mix ecto.migrate
mix run apps/thundermoon/priv/repo/seeds.exs
mix phx.server > log/phoenix.log 2>&1