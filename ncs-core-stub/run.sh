#!/bin/bash

bundle install
rackup ncs_core_stub.ru -p 4567
