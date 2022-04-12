# This is my site

## How to build this locally

1. Clone this repository

2. Prepare Hugo

3. Update submodule

```shell
$ git submodule update --init
```
4. Hugo server

```shell
$ hugo server
Start building sites …
hugo v0.93.1+extended darwin/amd64 BuildDate=unknown
                   | EN | CN
-------------------+----+-----
  Pages            | 41 |  9
  Paginator pages  |  0 |  0
  Non-page files   |  0 |  0
  Static files     | 15 | 15
  Processed images |  0 |  0
  Aliases          | 16 |  3
  Sitemaps         |  2 |  1
  Cleaned          |  0 |  0

Built in 74 ms
Watching for changes in /{somewhere}/{archetypes,content,static,themes}
Watching for config changes in /{somewhere}/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```
## How to make changes
1. Create markdown
```shell
$ hugo new notes/linux.zh.md
```
2. Write.

3. Create the newest site
```shell
$ hugo
```
4. Add changes in docs/ and the newly file
```shell
$ git add .
$ git commit -sm"Add linux.zh.md"
$ git push origin
```

Powered by Hugo and Hello-Friend-NG theme.
