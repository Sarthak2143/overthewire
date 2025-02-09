intresting things as i came across the levels in otw/bandit

1. if we have 20 directories and there is a file of a certain size, how do we get it?

we'll be using a bash script that uses the `find` command to find our file
```bash
#!/bin/bash

target_size = 1024

for i in {1..20}; do
	find "dir${i}" -type f -size "${target_size}c" ! -executable -print
done
```

`-type f` refers to only count files
the `c` in the `-size` flag refers to bytes, hence we're searching for a 1024 bytes file
`! -executable` means don't count execs
`-print` means print the result

2. how do we check the size of a file?

first we'll create a file of a specific size (how?)

`yes 'this is a test file. | head -c 10MB > test.txt`

here, `yes` returns the quoted until it's interrupted and then we're passing the output to `head` with the `-c 10 MB` flag which limits the file size to 10 MB and then we saves the output to `testfile.txt`.

methods to find size:

- using the `du` (disk usage) command
```bash
sarthak@archlinux ~/s/o/bandit> du -sh test.txt
9.6M    test.txt
```

why its in 9.6M when we made it of 10MB?
here `M` is Mebibytes not Megabytes
Megabyte(MB): 10^6 bytes = 1,000,000
Mebibyte(MiB): 2^20 bytes = 1,048,576

hence 10MB = 10,000,000 in MiB would be $10,000,000 / 1,048,576$ = $9.53674$ MiB
rounded off its 9.6 MiB

here in the `-sh` flag, `s` tells the `du` command to provide summary of file usage and `h` stands for human-readable format.

- using the `ls` (list) command
```bash
sarthak@archlinux ~/s/o/bandit> ls -lh test.txt
-rw-r--r-- 1 sarthak users 9.6M Jan 26 10:50 test.txt
```

the `-lh` flag means long listing and human readable

- using the `stat` command
```bash
sarthak@archlinux ~/s/o/bandit> stat -c %s test.txt  
10000000
```

it returns the output in bytes.
`-c` means to add specify the format, `%s` means total size in bytes

- using the `wc`(word count) command
```bash
sarthak@archlinux ~/s/o/bandit> wc -c test.txt  
10000000 test.txt
```

the `-c` flag means to count the bytes

3. how to find a file that is owned by a specific owner and a specific group

```bash
find directory_location -group {group_name} -user {user_name}
```

4. how to the find a line that only appears once in a file
```bash
for dir in $(sort data.txt | uniq); do
  count=$(grep -c "^$dir$" data.txt)
  if [ "$count" -eq 1 ]; then
    echo "$dir"
  fi
done
```

here we are looping through all the lines and checking for their number of occurence

5. how to make a temporary directory

use the following it'll make a temporary directory in /tmp:
```bash
mktemp -d
```

6. how to get the original file back from its object dump
```bash
xxd -r {file_name}
```

7. how to check file type
```bash
file {file_name}
```

8. how to decompress files

- for `.gz` use `gzip`
```bash
gzip -d {file_name}.gz
```

- for `bzip2` type use `bzip2`
```bash
bzip2 -d {file_name}
```

- for `tar`
```bash
tar -xvf {file_name}.tar
```

9. how to use private ssh key to ssh in the system

- first, check for the perms of ssh file, it must be readble and writable only to the owner
to give read/write perms to only owner:
```bash
chmod 600 ssh.key
```

- after giving the perms use this command:
```bash
ssh {host} -p {port} -l {login_name/username} -i {/path/to/key}
```

10. how to send and listen on a port with `nc`(netcat)

for server:
```bash
nc -l -p {port}
```

for client:
```bash
nc {host} {port}
```

for client with ssl/tls encryption:
```bash
netcat --ssl {host} {port}
```

11. check on a range of ports which are open
```bash
for port in {1..100}; do nc -zv hostname $port && echo "port $port is open"; done
```

this script checks which uses ssl and which does not
```bash
for port in $(seq 1 100); do
  nc -zv localhost $port &>/dev/null && echo -n "port $port is open && " && \
  echo | openssl s_client -connect localhost:$port 2>/dev/null | grep -q "CONNECTED" && \
  echo "using SSL/TLS" || echo "not using SSL/TLS"
done
```

12. ssh with a forcefull different shell
```bash
ssh {host} -p {port} -l {login_name/username} -i {/path/to/key} -t "/bin/sh"
```

13. how to send a text message whenever someone connects to a certian port
```bash
echo "you joined." | nc -lvnp 1234
```

it starts a listener on port 1234 and whoever connects to it, recieves the message

14. how to break out of the `more` command

we can this command by making the terminal as small as possible, it'll open the "interactive" mode. or you can just use a script before running the `more` command to do so
```bash
# resize the terminal  
printf "\033[8;3;50t"  # Resize to 3 lines tall
```

now if you type `v` it'll open `vim` right in the file that was opened with more. 

15. opening shell in vim

in the `NORMAL` mode use the `:shell` command to open the default user shell
if the default shell is not `/bin/bash` you can set it by the command
```bash
:set shell=/bin/bash
```

it'll change the `shell` variable

16. how to git clone from ssh

```bash
git clone ssh://{user}@{host}:{port}/{repo_dir}
```

17. show all branches in the repo

```bash
git branch -a
```

18. see the logs of git in detail with the changes made

```bash
git log
```

it shows the commits history

```bash
git log -p
git log --patch
```

it shows the commits history with the patches/changes made

19. change the branch of the repo

```bash
git checkout {branch}
```

20. using git tags

git tags are like bookmarks or milestones in a git repo. they're used to mark specific points in the history as important, usually for releases

this command shows the tags:
```bash
git tag
```

this command shows the changes/info in the tag:
```bash
git show {tag_name}
```

21. exploiting the uppershell

this shell converts every commands to uppercase, so normal commands won't work here.
there is something in linux that are uppercase and that are variables.
especially the `SHELL/0` variable

for breaking out, run the `$0` command