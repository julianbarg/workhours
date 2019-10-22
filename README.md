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
because I am a lazy bastard. The functions are saved to `~/.bashrc` to
make them permanently available in the console.

### start_job (job_name)

Provide the name of the job you are working on as the argument.

```bash
function start_job () {
	echo "${1},1,$(date -Iminutes)" >> ~/workhours/timestamps.csv
	tail -1 ~/workhours/timestamps.csv
}
```

### end_job

Ends the last job. the function looks up the name of the last job to make 
sure that records are consistent.

```bash
function end_job () {
	job="$(tail -1 ~/workhours/timestamps.csv | grep -o -P '^[^,]*')"
	echo "$job,0,$(date -Iminutes)" >> ~/workhours/timestamps.csv
	tail -2 ~/workhours/timestamps.csv
}
```

### check_job

Check whether you have successfully recorded ending the last project, or see 
what job you are supposedly working on.

```bash
function check_job {
	tail -1 ~/workhours/timestamps.csv
}
```

### pretty_csv

Helper function to print `timestamps.csv` to the console in a readable 
format.
Source: https://www.stefaanlippens.net/pretty-csv.html 

```bash
function pretty_csv {
	column -t -s, -n "$@" | less -F -S -X -K
}
```

## Bash script `sync_workhours.sh`

The bash script needs to have the appropriate file permissions to be 
executable. For instance, navigate to the project folder in the terminal
and run `sudo chmod 755 sync_workhours.sh`. To run, the repository should 
be setup to use ssh rather than e.g., the github url for pull and push (
otherwise, when pushing, the crontab will be prompted to enter the password
and fail). See https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh 
on how to set this up. In the current setup, the bash script uses keychain to 
ensure that it can use the ssh key. keychain can be installed via apt-get, and 
needs to be run in the terminal once (`keychain`) to be set up. The bash script 
also needs to be added to crontab to run periodically. Further, run `sudo chmod -R
 a+rwX .` in the folder to ensure that crontab can use `git commit`. 
 Finally, add the bashcript to crontab (`crontab -e`), e.g., by adding these 
 lines at the bottom:
 ```cron
 MAILTO=""
 0 * * * * /home/usr/workhours/sync_workhours.sh >> /home/use/workhours/sync_workhours.log 2>&1
 ```
 (Substitute usr with your user name.)