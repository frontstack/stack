# FrontStack

Self-contained, portable and ready-to-run GNU/Linux x64 software stack for modern node-based Web development

## Usage

1. Run `bash.sh` to create a new bash session with specific environment variables

2. Create your workspace directory and start coding!

## Update

You can easily upgrade the whole FrontStack environment simply running the following script:

```shell
$  scripts/update.sh
```

This process will autodiscover new FrontStack versions and it will do all the upgrade process for you

Note that all files and directories will be overwritten, except the `packages/` directory.

You probably will need to install Node or Ruby packages, right? 
And what happens if I do an environment upgrade?

All the Node packages or Ruby gems you install will be installed in the `packages/` directory and it will be ignored by the update process, so all the installed packages will remain between updates.

## Packages

See `PACKAGES.md` file

## Where are the binaries?

If you are reading this from Github, you should take into account that FrontStack binaries are not being versioned by a SCM ([read this](http://blog.bintray.com/2013/05/30/google-and-github-insist-go-store-your-binaries-in-a-proper-place/?shareadraft=51a74b1186613)).

All the binaries are hosted in SourceForge, so you can download any public FrontStack release from [here](https://sourceforge.net/projects/frontstack/files/releases/).

## To Do

- Add detailed documentation and FAQ
- Improve Python support
- Add test scripts (test dynamic dependecies, binaries exit codes...)

## Issues

Feel free to report any issue you experiment or improvements via [Github][https://github.com/frontstack/stack/issues]

## Authors

- [Tomas Aparicio](https://github.com/h2non)

## License

Bash scripts are releases under the [WTFPL](http://www.wtfpl.net/txt/copying/)
