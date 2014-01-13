# FrontStack

Self-contained, portable and ready-to-run GNU/Linux software stack for modern node-based Web development

## Usage

1. Run `bash.sh` to create a new bash session with the isolated environment variables

2. Create your workspace directory and start coding!

## Update

You can easily upgrade the whole FrontStack environment simply running the following script:

```shell
$ frontstack update
```

This process will autodiscover new FrontStack versions and it will do all the upgrade process for you

Note that all files and directories will be overwritten, except the `packages/` directory.

You probably will need to install Node or Ruby packages, right? 
And what happens if I do an environment upgrade?

All the Node packages or Ruby gems you install will be installed in the `packages/` directory and it will be ignored by the update process, so all the installed packages will remain between updates.

## FrontStack CLI

```
  FrontStack CLI commands:

  update
    Update FrontStack if new versions are available
  version  
    Show the current FrontStack version
  where [package]
    Show path where a given packages is located
  info
    Show FrontStack project useful links
  help
    Show this info

  Examples:

  $ fronstack update
  $ fronstack where ruby
```

## Requirements

- GNU/Linux 64 bit
- 512MB RAM (>=768MB recommended)
- 1GB HDD
- Internet access (HTTP/S)

## Packages

See the [PACKAGES](https://github.com/frontstack/stack/blob/master/PACKAGES.md) file

## Where are the binaries?

If you are reading this from Github, you should take into account that FrontStack binaries are not being versioned by a SCM ([read this](http://blog.bintray.com/2013/05/30/google-and-github-insist-go-store-your-binaries-in-a-proper-place/?shareadraft=51a74b1186613)).

All the binaries are hosted in SourceForge, so you can download any public FrontStack release from [here](https://sourceforge.net/projects/frontstack/files/releases/).

## To Do

- Add detailed documentation and FAQ
- Improve Python support
- Add Go support
- Add test scripts (test dynamic dependecies, binaries exit codes...)

## Issues

Feel free to report any issue you experiment or improvements via [Github](https://github.com/frontstack/stack/issues)

## Authors

- [Tomas Aparicio](https://github.com/h2non)

## License

Bash scripts are releases under the [WTFPL](http://www.wtfpl.net/txt/copying/)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/frontstack/stack/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
