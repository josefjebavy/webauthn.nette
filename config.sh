#!/bin/bash

cp '.env [example]' .env
cp 'config/local.neon [example]' config/local.neon


sqlite3 .data/main.sqlite3 < .data/schema.sql
sqlite3 .data/main.sqlite3 < .data/fixtures.sql


openssl genrsa \
    -out .ssl/ca.key 2048


cp '.ssl/ca.conf [example]' .ssl/ca.conf

openssl req -x509 -new -days 3650 -nodes -sha256 \
    -config .ssl/ca.conf \
    -key .ssl/ca.key \
    -out .ssl/ca.crt

openssl x509 -outform DER \
    -in .ssl/ca.crt \
    -out .ssl/ca.der

openssl dhparam \
    -out .ssl/dhparam 2048

openssl genrsa \
    -out .ssl/server.key 2048



cp '.ssl/server.csr.conf [example]' .ssl/server.csr.conf


openssl req -new \
    -config .ssl/server.csr.conf \
    -key .ssl/server.key \
    -out .ssl/server.csr



cp '.ssl/server.crt.conf [example]'  .ssl/server.crt.conf

openssl x509 -req -days 825 -sha256 \
    -CA .ssl/ca.crt \
    -CAkey .ssl/ca.key \
    -CAcreateserial \
    -CAserial .ssl/ca.seq \
    -extfile .ssl/server.crt.conf \
    -in .ssl/server.csr \
    -out .ssl/server.crt
