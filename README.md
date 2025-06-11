## NixOS System Configurations

Here is my NixOS configuration file.
almost all development is done in this environment.

### Setup

```
$ make iso/nixos.iso
```

Boot the VM, and using the graphical console, change the root password to "root":

```
$ sudo su
$ passwd
# change to root
```

At this point, verify /dev/sda exists. This is the expected block device where the Makefile will install the OS. If you setup your VM to use SATA, this should exist. If /dev/nvme or /dev/vda exists instead, you didn't configure the disk properly. Note, these other block device types work fine, but you'll have to modify the bootstrap0 Makefile task to use the proper block device paths.

Also at this point, I recommend making a snapshot in case anything goes wrong. I usually call this snapshot "prebootstrap0". This is entirely optional, but it'll make it super easy to go back and retry if things go wrong.

Run ifconfig and get the IP address of the first device. It is probably 192.168.58.XXX, but it can be anything. In a terminal with this repository set this to the NIXADDR env var:


`$ export NIXADDR=<VM ip address>`

The Makefile assumes an Intel processor by default. If you are using an
ARM-based processor (M1, etc.), you must change `NIXNAME` so that the ARM-based
configuration is used:

```
$ export NIXNAME=vm-aarch64
```

Perform the initial bootstrap. This will install NixOS on the VM disk image
but will not setup any other configurations yet. This prepares the VM for
any NixOS customization:

```
$ make vm/bootstrap0
```

After the VM reboots, run the full bootstrap, this will finalize the
NixOS customization using this configuration:

```
$ make vm/bootstrap
```

You should have a graphical functioning dev VM.

At this point, I never use Mac terminals ever again. I clone this repository
in my VM and I use the other Make tasks such as `make test`, `make switch`, etc.
to make changes my VM.
