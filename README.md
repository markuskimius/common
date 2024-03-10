> [!CAUTION]
> This package is now archived.
> Please use [core](https://github.com/markuskimius/core) instead (it's faster).
> 
> The most notable difference between common and core is that common uses JSON config files;
> core uses CSV config files which is faster to read.


# common
Unix utilities


## Like what?

* `ansi` - print the ansi color codes in color to stdout.
* `body` - filter all but the first line of text.
* `grep1` - grep that always matches the first line of a file.
* `hi` - highlight text matching regex in a file.
* `nu` - cat with line numbers.
* `un` - cat with reverse line numbers.
* `open` - open a file or the Finder/Explorer window from the macOS or Cygwin
  terminal.
* `start` - same as `open`.
* `mancat` - print the man page from a man file.
* `pidtree` - print the processes matching a regex, all of its children, and
  all of its ancestors, as a tree.
* `left` - print only the left part of a text file that fits inside the
  terminal width.

... plus more.


## Installation

Common requires [dpm].  Install dpm first then run the following command to
install and activate common:

```bash
$ dpm install https://github.com/markuskimius/common.git
$ dpm activate common
```

Then log out and log back in.


## License

[GPLv2]


[GPLv2]: <https://github.com/markuskimius/common/blob/main/LICENSE>
  [dpm]: <https://github.com/markuskimius/dpm>

