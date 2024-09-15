# Browser Jam

Entry for the first [Browser Jam](https://github.com/BrowserJam/browserjam).

- [x] tokenizing
- [ ] parsing (wip)
- [ ] rendering

Output so far...
```
Tree: HTMLDocument(root:
<HTML>
  <HEADER>
    <TITLE>
      The World Wide Web project
  <BODY>
    <H1>
      World Wide Web
    The WorldWideWeb (W3) is a wide-area
    <A NAME=0 HREF="WhatIs.html">
      hypermedia
    information retrieval initiative aiming to give universal access to a large universe of documents.
)
```

## Parser TODO

- [x] ignore extraneous </A> closing tag
- [ ] close unclosed tags (random <P>)

# Build

Uses Swift 6.0 snapshot

## Ubuntu / WSL2

```sh
sudo apt install libglfw3-dev libglfw3 xorg-dev
```

### Troubleshooting

**MESA: error: ZINK: failed to choose pdev**

Install latest stable Mesa drivers
```sh
sudo add-apt-repository ppa:kisak/kisak-mesa
sudo apt upgrade
```
