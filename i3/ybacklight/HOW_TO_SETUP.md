# OK, first of all be careful because this can brick your system

---

## DANGER DANGER EDITING `/etc/sudoers` REQUIRED

### WHY

`ybacklight` -inc and -dec require sudo privileges, but if you bind it to i3 shortcut
it won't be able to prompt for password or anything and it will be run without sudo

that's why we need to allow this particular program to run with sudo privileges
but without password

read on if you aren't scared yet

### HOW

#### step1 add the `ybacklight` to /bin

```
sudo ln -s /home/tarnas/.config/i3/ybacklight/ybacklight /bin
```

easy enough, `ybacklight` should now be globally available from any shell

> ## YOU ALREADY FUCKED YOUR /etc/sudoers
>
> - restart into 'recovery mode' (advanced boot options)
> - enable networking (because otherwise your filesystem is mounted as readonly)
> - drop to root shell
> - visudo
> - correct the sudoers file
> - you are safe

#### step2 (now that you read recovery steps):

```
sudo visudo
```

add this line AFTER the already present `%sudo ALL=(ALL:ALL) ALL` line

sudoers file takes the LAST matching privilege, so any exceptions should be added at the end

```
%sudo   ALL=(root) NOPASSWD: /bin/ybacklight
```

when you write to sudoers, `sudo ybacklight` should not prompt for password
and can be used from i3 binding
