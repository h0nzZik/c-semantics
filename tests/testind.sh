#!/bin/bash

function pr() {
  echo "$@"
  sleep 1
}

function indent() {
  "$@" | ../scripts/indenter
}

function f() {
  pr "< f>"
  #indent c
  pr "< f>"
}
function e() {
  pr "< e>"
  indent f
  pr "< e>"
}
function d() {
  pr "< d>"
  indent e
  pr "< d>"
}
function c() {
  pr "< c>"
  indent d
  pr "< c>"
}
function b() {
  pr "< b>"
  indent c
  pr "< b>"
}

function a() {
  pr "< a>"
  indent b
  pr "</a>"
}

a
