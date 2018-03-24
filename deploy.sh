#!/bin/bash

export PORT=5106
export MIX_ENV=prod
export GIT_PATH=/home/checkers/src/Checkers

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "checkers" ]; then
	echo "Error: must run as user 'checkers'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/Checkers ]; then
	echo mv ~/www/Checkers ~/old/$NOW
	mv ~/www/Checkers ~/old/$NOW
fi

mkdir -p ~/www/checkers
REL_TAR=~/src/Checkers/_build/prod/rel/Checkers/releases/0.0.1/Checkers.tar.gz
(cd ~/www/Checkers && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/checkers/src/Checkers/start.sh
CRONTAB

#. start.sh
