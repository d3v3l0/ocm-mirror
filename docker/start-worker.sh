#!/usr/bin/env bash

set -Eeuo pipefail

if [[ $FORCE_UPGRADE_DATA == 'true' || $FORCE_UPGRADE_DATA == '1' ]]; then
  # Empty MongoDB
  # TODO: Delete all collections
  
  # ----
  # Download MongoDB dump from official OCM repo
  # https://github.com/openchargemap/ocm-data

  # - poi.json.gz
  # - reference.json
  # - reference.json.gz
  #
  # - `poi.json.gz` is a gzipped export of our MongoDB cache. This is a complete export of our POI database. When extracted this file is hundreds of MB in size.
  # - `reference.json` and `reference.json.gz` are an export of our current reference data (connection types, network operators, countries etc)
  #
  # **Note**: you should not consume or key on the `_id` data fields as these are artifacts of our MongoDB export database cache and will change over time as our cache is refreshed.
  # ----

  # TODO: remove
  #mongoexport --collection=reference --db=ocm_mirror --out=reference.json
  #mongoexport --collection=poi --db=ocm_mirror --out=poi.json

  # TODO: Install "aria2"
  aria2c -x10 -k2M https://github.com/openchargemap/ocm-data/raw/master/poi.json.gz -d /tmp/
  aria2c -x1 https://github.com/openchargemap/ocm-data/raw/master/reference.json.gz -d /tmp/
  
  # TODO: Import downloaded data into MongoDB
  gunzip /tmp/reference.json.gz | mongoimport --collection=reference --db=ocm_mirror
  gunzip /tmp/poi.json.gz | mongoimport --collection=poi --db=ocm_mirror
fi

exec dotnet OCM.API.Worker.dll | ts '[%Y-%m-%dT%H:%M:%.SZ]'
