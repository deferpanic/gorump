#
# Regular cron jobs for the gorump package
#
0 4	* * *	root	[ -x /usr/bin/gorump_maintenance ] && /usr/bin/gorump_maintenance
