#!/bin/bash

# This script appends to the PATCH version of the Semantic Version of the pom file, intended to be called after every commit

line=`awk '/SNAPSHOT/{ print NR; exit }' "${PWD}/pom.xml"`
str=`sed -n -e "$line"p "${PWD}/pom.xml"`

newstr="${str#*.}"
newstr="${newstr#*.}"
newstr="${newstr%-*}"

firststr="${str%-*}"
firststr="${firststr%-*}"
firststr="${firststr%.*}"

secondstr="${str#*-}"

sed -i "${line}s~.*SNAPSHOT.*~${firststr}.$(($newstr + 1))-${secondstr}~" "${PWD}/pom.xml"
