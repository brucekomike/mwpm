# mediawiki package manager
this is a package(page) manger for mediawiki.

mainly used for importing page from exsiting wiki

## requirements
- curl
- jq
- bash
## features
- pure shell implementation
- export/import pages by
  - plain wikitext (single page per .wikitext file)
  - xml (multi-pages per .xml file)
  - interwiki (no export option) 
## how to use
### install dependency
ubuntu
```
sudo apt update && sudo apt upgrade
sudo apt install curl jq
```
### install (or update) a package
- `cp config.sh.example config.sh`
- `./login.sh`
- `./install-[type].sh <package-definition-file>`

## reference
### export 
- https://www.mediawiki.org/wiki/API:Query (xml and wikitext)
### import
- https://www.mediawiki.org/wiki/API:Import (xml and interwiki)
- https://www.mediawiki.org/wiki/API:Edit (wikitext)