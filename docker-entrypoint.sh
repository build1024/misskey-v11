#!/bin/sh

npx ts-node ./node_modules/typeorm/cli.js migration:run && node ./index.js
