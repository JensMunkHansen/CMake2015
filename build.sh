#!/bin/bash
rm -Rf ./FooBar/build
rm -Rf ./FooBarUser/build
cmake -B./FooBar/build -H./FooBar
cmake --build ./FooBar/build

cmake -B./FooBarUser/build -H./FooBarUser
cmake --build ./FooBarUser/build
