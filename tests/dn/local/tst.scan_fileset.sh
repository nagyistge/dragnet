#!/bin/bash

#
# tst.scan_fileset.sh: tests basic "scan" operations on a small fileset.
#

set -o errexit
. $(dirname $0)/../common.sh

function scan
{
	echo "# dn scan" "$@"
	dn scan "$@" test_input
	echo

	echo "# dn scan --points" "$@"
	dn scan --points "$@" test_input | sort -d
	echo
}

dn_clear_config
dn datasource-add test_input --path=$DN_DATADIR \
    --time-format=%Y/%m-%d --time-field=time
. $(dirname $0)/../scan_testcases.sh

#
# Check GNUplot output.
#
dn scan -b timestamp[field=time,date,aggr=lquantize,step=86400] \
    --gnuplot test_input
dn scan -b req.method --gnuplot test_input

#
# The "before" and "after" filters should prune the number of files scanned.
# When comparing output, it's important to verify the correct number of records
# returned as well as the expected number of files scanned.  Chop off the root
# of the workspace so that this test doesn't fail when run from different
# absolute directories.
#
scan --dry-run -b 'timestamp[date,field=time,aggr=lquantize,step=86400]' 2>&1 |
    sed -e s"#$__dir/*##"
scan --counters -b 'timestamp[date,field=time,aggr=lquantize,step=86400]' 2>&1

scan --dry-run --counters --after 2014-05-02 --before 2014-05-03 2>&1 |
    sed -e s"#$__dir/*##"
scan --counters --after 2014-05-02 --before 2014-05-03 2>&1

scan --dry-run --counters \
    -b 'timestamp[date,field=time,aggr=lquantize,step=60]' \
    --after "2014-05-02T04:05:06.123" --before "2014-05-02T04:15:10" 2>&1 |
    sed -e s"#$__dir/*##"
scan --counters -b 'timestamp[date,field=time,aggr=lquantize,step=60]' \
    --after "2014-05-02T04:05:06.123" --before "2014-05-02T04:15:10" 2>&1

dn_clear_config
