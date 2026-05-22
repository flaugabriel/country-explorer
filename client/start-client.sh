#!/bin/bash
set -e
npm install
npm run build
npx --yes serve -s build -l 3000