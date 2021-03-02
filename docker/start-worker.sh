#!/usr/bin/env bash

set -Eeuo pipefail

if [[ $FORCE_UPGRADE_DATA == 'true' || $FORCE_UPGRADE_DATA == '1' ]]; then
  # Empty MongoDB
  # ******************************************
  # TODO: purge MongoDB
  # TODO: Delete all collections from the MongoDB
  # ******************************************

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
  # mongoexport --collection=reference --db=ocm_mirror --out=reference.json
  # mongoexport --collection=poi --db=ocm_mirror --out=poi.json

  # TODO: Install "aria2"
  
  # Downloading fresh official MongoDB dump shnapshots from GitHub repo `openchargemap/ocm-data`:
  #  1) `poi.json.gz`
  aria2c --max-connection-per-server=16 \
    --min-split-size=2M \
    --continue=true \
    --allow-overwrite=true \
    --auto-file-renaming=false \
    https://github.com/openchargemap/ocm-data/raw/master/poi.json.gz \
    -d /tmp/

  # 2) `reference.json.gz`
  aria2c --max-connection-per-server=1 \
    --min-split-size=2M \
    --continue=true \
    --allow-overwrite=true \
    --auto-file-renaming=false \
    https://github.com/openchargemap/ocm-data/raw/master/reference.json.gz \
    -d /tmp/

  # Importing downloaded data into MongoDB
  mongoimport \
    --collection=reference \
    --db=ocm_mirror \
    < <(gunzip /tmp/reference.json.gz)

  mongoimport \
    --collection=poi \
    --db=ocm_mirror \
    < <(gunzip /tmp/poi.json.gz)
fi

# Starting Worker daemon
exec dotnet OCM.API.Worker.dll | ts '[%Y-%m-%dT%H:%M:%.SZ]'
