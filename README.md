IntelliJ Idea installation script for Linux
========================================================

"install-idea.sh" is an installation script for setting up IntelliJ Idea on Debian based Linux Operating Systems.

Currently, the `install-idea.sh` script supports `tar.gz` distribution.

I'm mainly using Ubuntu and therefore this script is tested only on different versions of Ubuntu.

## Prerequisites

The "install-idea.sh" script will not download the IntelliJ Idea distribution. You must download Idea `tar.gz` distribution.

## Installation

You need to provide the Idea distribution file (`tar.gz`) and the IntelliJ Idea Installation Directory.
The default value for IntelliJ Idea installation directory is "/opt"

```console
$ ./install-idea.sh -h

Usage: 
install-idea.sh -f <idea_dist> [-p <idea_installation_dir>]

-f: The idea tar.gz file.
-p: IntelliJ Idea installation directory. Default: /opt.
-h: Display this help and exit.

```

## License

Copyright (C) 2021 Eric Vlaskin
