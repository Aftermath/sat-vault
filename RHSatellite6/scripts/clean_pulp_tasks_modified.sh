#!/bin/bash
STATE=""
for TASK in `pulp-admin tasks list | egrep '^Task Id:|^State:' | sed -e 's,^Task Id: ,,' -e 's,^State: ,,'`; do
        if [ "$STATE" = "" ]; then
                STATE=$TASK
        else
                if [ $STATE != Successful ] && [ $STATE != Cancelled ] && [ $STATE != Failed ]; then
                        #pulp-admin tasks details --task-id=$TASK
			echo "Cancelling $TASK.."
                        pulp-admin tasks cancel --task-id=$TASK
                fi
                STATE=""
        fi
done
