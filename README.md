README
==========

`gsu` is a Privileged Identity Management (PIM) Tool for GCP. This tool allows you **Just in Time access control** like `su` command. It's the best way to follow the least privilege principle.

ref:
- [GCPに管理者権限で入るのをやめる！ sudoコマンドのようなJust in Timeな権限管理](https://zenn.dev/koduki/articles/0a06a881d70397)

CLI
----------

```bash
$ gsu: Switch GCP user role.
usage:
    gsu {group_name}
    gsu -l
    gsu -la
    gsu config scaffold
    gsu config set API_URL {API URL}
    gsu admin attach {user_name} {group_name}
    gsu admin detach {user_name} {group_name}
    gsu admin groups {user_name}
```

Install CLI
-----------

```bash
$ sudo ln -s `pwd`/cli/gsu /usr/bin/gsu
$ gsu config scaffold
```

Deploy API
---------

[API](api/README.md)
