# 002: Run a service and break it

## Evidence

### a. PID, parent, user

```text
@Vishisht16 ➜ /workspaces/devops-lab (main) $ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   2800  1904 ?        Ss   05:26   0:00 /bin/sh -c echo Container started trap "exit 0" 15  exe
vscode       411  0.0  0.0   2800  1780 ?        Ss   05:26   0:00 /bin/sh
root         435  0.0  0.0   2800  1808 ?        Ss   05:26   0:00 /bin/sh
vscode       583  0.0  0.0   2800  1916 ?        Ss   05:26   0:00 sh /home/vscode/.vscode-remote/bin/16507d91be0dc1ce4f94
vscode       592  0.4  2.1 1813132 175172 ?      Rl   05:26   0:07 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       615  2.2  4.6 18782892 382048 ?     Sl   05:26   0:37 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       630  0.1  1.7 18546776 141460 ?     Sl   05:26   0:02 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       633  0.0  0.7 1661872 59272 ?      Sl   05:26   0:00 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       732  0.1  0.9 1550000 79272 ?      Sl   05:26   0:02 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       768  0.0  1.0 1504708 86520 ?      Sl   05:27   0:00 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       775  0.4  2.2 1591736 180420 ?     Sl   05:27   0:07 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       785  0.1  0.6 736108 50244 ?       Sl   05:27   0:01 /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04d4d0430210
vscode       816  0.0  0.0   2800  1956 ?        Ss   05:27   0:00 /bin/sh
root         857  0.0  0.0   2800  1920 ?        Ss   05:27   0:00 /bin/sh
vscode      1191  0.0  0.0   9316  5628 pts/1    Ss   05:27   0:00 /bin/bash --init-file /vscode/bin/linux-x64/16507d91be
vscode      9090  0.0  0.0   9184  5516 pts/0    Ss+  05:45   0:00 /bin/bash --init-file /vscode/bin/linux-x64/16507d91be
vscode     12572  0.0  0.0   9184  5524 pts/2    Ss   05:54   0:00 /bin/bash --init-file /vscode/bin/linux-x64/16507d91be
vscode     12752  0.2  0.2  29468 19540 pts/1    S+   05:54   0:00 python3 app.py
vscode     12914  0.0  0.0   2800  1880 ?        S    05:54   0:00 /bin/sh -c "/vscode/bin/linux-x64/16507d91be0dc1ce4f94c
vscode     12915  0.0  0.0   7740  3532 ?        S    05:54   0:00 /bin/bash /vscode/bin/linux-x64/16507d91be0dc1ce4f94c04
vscode     12918  0.0  0.0   6112  2056 ?        S    05:54   0:00 sleep 1
root       12925  0.0  0.0   6112  2084 ?        S    05:54   0:00 sleep 1
vscode     12927  0.0  0.0  11324  4408 pts/2    R+   05:54   0:00 ps aux

@Vishisht16 ➜ /workspaces/devops-lab (main) $ ps -o ppid= -p 12752
    1191

@Vishisht16 ➜ /workspaces/devops-lab (main) $ ps -o user= -p 12752
vscode

@Vishisht16 ➜ /workspaces/devops-lab (main) $ pgrep -f app.py
20450 

```

*(Note: Because of a VS Code task or similar mechanism, the Python parent differs; this also represents a separate run.)*

### b. Address and port

* **Address:** `localhost`
* **Port:** `8000`

### c. Behavior under load/hang

The process still showed up in `ps`, but stopped responding after the hang request. This occurred because the hang request was never responded to, and the server was single-threaded (processing only one task at a time).

### d. kill vs. kill -9

* **`kill` (SIGTERM):** Gracefully terminates the process.
* **`kill -9` (SIGKILL):** Forcefully kills the process immediately.

### e. Crash response

The OS exit code was `3`, but the program crashed and returned a `500` error code.

---

### check.sh

```text
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000
2026-10-15 06:25:02 http://localhost:8000 UP
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000
2026-10-15 06:26:06 http://localhost:8000 UP
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000
2026-10-15 06:26:09 http://localhost:8000 UP
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/hang
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/hang
^[[A^[[A@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/
2026-10-15 06:27:48 http://localhost:8000/ UP
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/crash
2026-10-15 06:27:55 http://localhost:8000/crash DOWN (status code: 500)
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/check.sh http://localhost:8000/crash

```

### supervise.sh

```text
@Vishisht16 ➜ /workspaces/devops-lab (main) $ scripts/supervise.sh 
[Supervisor] Starting Python app...
Server running on port 8000...
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET /hang HTTP/1.1" 200 -
[Supervisor] Health check failed (1/3)
[Supervisor] Health check failed (2/3)
[Supervisor] Health check failed (3/3)
[Supervisor] 3 consecutive failures reached. Killing app (PID: 30628)...
[Supervisor] App exited or was terminated. Restarting in 2 seconds...
scripts/supervise.sh: line 55: 30628 Killed                  python3 app.py
[Supervisor] Starting Python app...
Server running on port 8000...
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET / HTTP/1.1" 200 -
[127.0.0.1] "GET /crash HTTP/1.1" 500 -
[Supervisor] App exited or was terminated. Restarting in 2 seconds...
[Supervisor] Starting Python app...
Server running on port 8000...
[127.0.0.1] "GET / HTTP/1.1" 200 -
^CStopping supervisor...

```

## What broke

Nothing

## AI used for

Checking out some commands, writing check.sh, supervise.sh and app.py.