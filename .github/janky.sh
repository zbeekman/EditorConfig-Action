#!/usr/bin/env bash

echo $MY_VAR

find . -name $1 -exec echo {} \;

FOOBAR=yes

echo "But it's never used"
