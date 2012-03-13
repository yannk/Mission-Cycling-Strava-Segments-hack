#!/bin/bash

## Download raw json from Strava API and store them on disk at a well known
## location so that we can use it from a webpage. All this because Strava doesn't
## support JSONP

club_id=15 # MC, the bests, oeuf corse.
server=http://www.strava.com
current="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
root="$current/.."
confdir=$root/conf
datadir=$root/data

function download() {
    local segment_id=$1
    local day=$2

    local dir="$datadir/$day"
    mkdir -p $dir || (echo "error creating directory: $dir" && exit -1)
    local url=$(segment_url $segment_id $day)
    curl -s -o $dir/$segment_id.json $url
}

function segment_url() {
    local segment_id=$1
    local day=$2
    echo "$server/api/v1/segments/$segment_id/efforts?clubId=$club_id&best=true&startDate=$day&endDate=$day"
}

day=${1:-`date "+%Y-%m-%d"`}
cat $confdir/segments.txt |
    while read segment_id; do
        download $segment_id $day
    done

