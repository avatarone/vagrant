This vagrant configuration sets up a virtual machine to run the new version of S2E currently in development 
(See [this repository](https://github.com/eurecom-s3/news2e) for more information).

Start the virtual machine with `vagrant --provider virtualbox up`, 
connect to it via `vagrant ssh -- -A`
(-A is for agent forwarding, so that you can directly commit to Github using your SSH key), 
and run the tests via `cd projects/news2e/tests; make check`. 

If you want to commit to Github, make sure to replace the repository URL of
the project with `git remote set-url origin git@github.com:eurecom-s3/project` where project is the project you want
to commit to (Use `git remote -v` to see get it from the current remote).
