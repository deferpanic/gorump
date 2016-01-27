This example shows how to build a more elaborate Go application consisting of multiple .go files.

Basically, only change is that you need to add all .go files to a single `go build` statement with "main" .go file being first. No additiona export or `import "C"` statements are needed.

As with other examples, running `make` will do the trick.
