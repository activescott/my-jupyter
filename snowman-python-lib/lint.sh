#!/bin/sh
python3 -m pylint --disable C --reports n -f colorized -j4 ./src/snowman/*
