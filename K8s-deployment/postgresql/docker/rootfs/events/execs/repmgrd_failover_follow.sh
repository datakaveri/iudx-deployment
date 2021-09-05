#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

. "$REPMGR_EVENTS_DIR/execs/includes/anotate_event_processing.sh"
. "$REPMGR_EVENTS_DIR/execs/includes/lock_standby.sh"
