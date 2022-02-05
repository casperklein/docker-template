# Headline1

See [Markdown-Cheatsheet][cheatsheet] for more information.

WYSIWYG: [editor.md](https://pandao.github.io/editor.md/examples/simple.html)

[Github Test](https://github.com/casperklein/test/edit/master/README.md)

## Code

```bash
`some code (one liner)`
```

    ```bash
    #!/bin/bash
    some
    lines of
    code
    ```
or

```bash
    4 spaces at the begining for a codeblock.
```

1. foo

        8 spaces for a codeblock in a listing

1. bar

## List

1. one
1. two
1. three
    * dot 1
    * dot 2
1. six

## Emphasis

Markdown applications don’t agree on how to handle underscores in the middle of a word. For compatibility, use asterisks to bold and italicize the middle of a word for emphasis.

**Don't do this:** `Love__is__bold`

**Do this:** `Love**is**bold`

<!-- markdownlint-disable MD049 MD050 -->
Italics with *asterisks* or _underscores_.

Bold with **asterisks** or __underscores__.

Italics and bold combined with **asterisks and *underscores***.

Strikethrough uses two tildes. ~~Scratch this.~~

## Images

![image attribut alt](https://github.com/netbox-community/netbox/raw/develop/docs/media/screenshots/home-light.png "img attribut title")

![foobar][netbox]

<!-- at the bottom you can put references -->
[netbox]: https://github.com/netbox-community/netbox/raw/develop/docs/media/screenshots/home-light.png "img attribute title"
[cheatsheet]: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
