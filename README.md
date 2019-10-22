# Workhours tracker

Purpose of this project is to track my workhours. There are three building
blocks in this project to make this possible. There are terminal functions
for recording the start and stop of a new workstep. The resulting .csv file
(timestampts.csv) can then be tracked with git. There is also a bash script
for automatically comitting and pushing the workhours to a remote repository.
This bash script should be run with crontab. A separate project (git: 
julianbarg/workhours_dashboard) is dedicated to visualizing the workhours.

## Terminal functions

The terminal functions allow to easily record the start or end of working
on a project. Note that the locations for the log file are hardcoded, 
because I am a lazy bastard.

### start_job (job_name)

Provide the name of the job you are working on as the argument.

```bash
function start_job () {
	echo "${1},1,$(date -Iminutes)" >> ~/workhours/timestamps.csv
	tail -1 ~/workhours/timestamps.csv
}
```

### end_job

Ends the last job. the function looks up the name of the last job to make sure 
that records are consistent.

```bash
function end_job () {
	job="$(tail -1 ~/workhours/timestamps.csv | grep -o -P '^[^,]*')"
	echo "$job,0,$(date -Iminutes)" >> ~/workhours/timestamps.csv
	tail -2 ~/workhours/timestamps.csv
}
```

### check_job

Check whether you have successfully recorded ending the last project, or 
see what job you are supposedly working on.

```
function check_job {
	tail -1 ~/workhours/timestamps.csv
}
```

