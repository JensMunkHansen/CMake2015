#!/bin/bash
cmake -B./FooBar/build -H./FooBar
cmake --build ./FooBar/build

cmake -B./FooBarUser/build -H./FooBarUser
cmake --build ./FooBarUser/build
