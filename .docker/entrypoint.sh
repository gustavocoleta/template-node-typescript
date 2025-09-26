#!/bin/bash

file=".npmrc"

if [ -f "$file" ]; then
    rm "$file"
fi

touch "$file"
echo "@vrsoftbr:registry=https://npm.pkg.github.com" >>"$file"
echo "//npm.pkg.github.com/:_authToken=$GITHUB_TOKEN" >>"$file"
echo "save-exact=true" >>"$file"
echo "legacy-peer-deps=true" >>"$file"

rm -rf ./dist

echo "Cleaning cache"
npm cache clean --force

echo "Running npm install"
npm install --legacy-peer-deps

echo "Running npm dedupe"
npm dedupe

echo "Building project"
npm run build


echo "Starting application in debug mode"
npm run debug

# echo "Starting application"
# npm start

# echo "Container is running, waiting attach..."
# tail -f /dev/null
