# CodeWrangler

Creates an archive copy of all monitored (configurable) database objects essentially maintaining a current and historic data dictionary.
Scans for new and changed objects on each execution.
The initial execution will store all existing objects first.

CodeWrangler consists of:
- *pr_CodeWrangler* and *udf_longHash* -- does the work
- *object_viewer* -- sample code for viewing the collected data
- *job.sql* -- creates a scheduled job to collect on a regular basis

To install, create the UDF, stored procedure, and SQL Agent job.

Data will be collected in master.dbo.[CodeWrangler].

Super handy for those Wild West shops that need to keep track of who deployed what and when...after the fact.
