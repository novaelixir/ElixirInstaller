#!/bin/bash
# For ubuntu only
export ELIXIR_VERSION=v1.8.1
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install make
git clone https://github.com/elixir-lang/elixir --depth 1 --branch $ELIXIR_VERSION && \
cd elixir && \
make && sudo make install && \
mix local.hex --force && \
mix local.rebar --force
