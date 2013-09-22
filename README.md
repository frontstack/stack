# FrontStack

Self-contained, portable and ready-to-run GNU/Linux x64 software stack for modern web projects development

`FrontStack is in beta stage`

## Usage

1. Run `bash.sh` to create a new bash session with specific environment variables

2. Create your workspace directory and start coding!

## Update

You can easily upgrade the whole FrontStack environment simply running the following script:

```shell
$  ~/scripts/update.sh
```

Note that all files and directories will be overwritten, except the `packages/` directory.

You probably will need to instal Node or Ruby packages via it's own package manager, right? And what happens if I do an upgrade?
All the Node packages or Ruby gems you install during your development will be installed at the `packages/` directory and this will be ignored by the update process, so all the packages will remain after updates.

## Packages

See `PACKAGES.md` file

## Where are the binaries?

If you are reading this from Github, you worth to know that FrontStack binaries a not versioned by any SCM ([read this](http://blog.bintray.com/2013/05/30/google-and-github-insist-go-store-your-binaries-in-a-proper-place/?shareadraft=51a74b1186613)).

All the binaries are hosted directly in SourceForge, so you can download any public release from [here](https://sourceforge.net/projects/frontstack/files/releases/).

## TODO

- Add documentation and FAQ
- Fix browsers fontconfig lib issue
- Improve Python support
- Add cURL support
- Add Git (and Perl) support?
- Python package manager
- Add test scripts (test dynamic dependecies, binaries exit codes...)

## Issues

Feel free to report any issue you experiment via Github:
https://github.com/frontstack/stack/issues

## Authors

- [Tomas Aparicio](https://github.com/h2non)

## License

Bash scripts are releases under the [WTFPL](http://www.wtfpl.net/txt/copying/)