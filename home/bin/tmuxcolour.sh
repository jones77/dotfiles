#!/usr/bin/env bash

sum=$(hostname | sum | cut -f1 -d' ')
echo "colour$(expr $sum % 256)"
