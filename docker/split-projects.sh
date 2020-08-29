#!/bin/bash

set -e -x

rm -rf build/loop build/lnd build/faraday
cp -r build/all build/loop
cp -r build/all build/faraday
mv build/all build/lnd
cp build/loop/loop.html build/loop/index.html
cp build/lnd/lnd.html build/lnd/index.html
cp build/faraday/faraday.html build/faraday/index.html
