#!/bin/bash

export PORT=5106

cd ~/www/Checkers
./bin/Checkers stop || true
./bin/Checkers start
