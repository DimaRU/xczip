# xczip

xczip - create xcframework zip archive for swift binary package. 
Creates an xcframework archive with a stable checksum that does not change when the build is repeated.

### Usage:

OVERVIEW: Create xcframework zip archive for swift binary package.

USAGE: xczip <path> --date <date> [--time <time>] [--output-path <output-path>]

ARGUMENTS:
  <path>                  Path to xcframework.

OPTIONS:
  --date <date>           Force compressed files modification date.
        Date format must be M-d-yyyy
  --time <time>           Force compressed files modification time.
        Time format must be hh:mm:ss
  -o, --output-path <output-path>
                          Created archive path.
  --version               Show the version.
  -h, --help              Show help information.
