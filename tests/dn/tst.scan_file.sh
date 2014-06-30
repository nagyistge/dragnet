#!/bin/bash

#
# tst.scan_file.sh: tests basic "scan" operations on files.
#

set -o errexit
. $(dirname $0)/common.sh

function scan
{
	echo "# dn scan" "$@"
	dn scan "$@" $DN_DATADIR/2014/05-01/one.log
	echo

	echo "# dn scan --points" "$@"
	dn scan --points "$@" $DN_DATADIR/2014/05-01/one.log | sort -d
	echo
}

. $(dirname $0)/scan_testcases.sh