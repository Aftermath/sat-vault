#!/bin/bash

# This will destroy ALL foreman task data in Satellite 6.
# Do not run if you are partial to any of this data.
#
# Can be useful for troubleshooting dynflow issues or performing a quick cleanup.


echo ""
echo "DELETING All task data"
echo ""

TABLE_COUNTS="select count(*) as foreman_tasks_tasks from foreman_tasks_tasks;
select count(*) as dynflow_execution_plans from dynflow_execution_plans;
select count(*) as dynflow_actions from dynflow_actions;
select count(*) as dynflow_steps from dynflow_steps;"

echo ""
echo "Table counts before:"
echo $TABLE_COUNTS | sudo -i -u postgres psql -d foreman

echo "Deleting foreman_tasks_tasks"
FT="TRUNCATE TABLE dynflow_envelopes,dynflow_delayed_plans,dynflow_steps,dynflow_actions,dynflow_execution_plans,foreman_tasks_locks,foreman_tasks_tasks;"

sudo -i -u postgres psql -d foreman -c "$FT"

echo "Done."

echo "Table counts after:"
echo $TABLE_COUNTS | sudo -i -u postgres psql -d foreman
