#!/bin/bash

export PORT=5106

cd ~/www/checkers
./bin/checkers stop || true
./bin/checkers start
