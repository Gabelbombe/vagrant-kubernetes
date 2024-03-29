#!/usr/bin/env bash
set -e

# define location of openssl binary manually since running this
# script under Vagrant fails on some systems without it
OPENSSL=$(which openssl)

function usage {
    echo "USAGE: $0 <output-dir>"
    echo "  example: $0 ./ssl/ca.pem"
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

OUTDIR="$1"

if [ ! -d $OUTDIR ]; then
    echo "ERROR: output directory does not exist:  $OUTDIR"
    exit 1
fi

OUTFILE="$OUTDIR/ca.pem"

if [ -f "$OUTFILE" ];then
    exit 0
fi

# establish cluster CA and self-sign a cert
openssl genrsa -out "$OUTDIR/ca-key.pem" 2048
openssl req -x509 -new -nodes -key "$OUTDIR/ca-key.pem" -days 10000 -out "$OUTFILE" -subj "/CN=kube-ca"

