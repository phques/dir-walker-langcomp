// dirWalker1.go
// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0
package main

import (
	"code.google.com/p/dirWalker1/dirtree"
	"fmt"
	"html"
	"strings"
)

//----------

// DirTreePrinter: output to stdout, indented

type DirPrint struct {
	depth int
}

func (d *DirPrint) spaces() string {
	nbSpaces := d.depth * 3
	return strings.Repeat(" ", nbSpaces)
}

func (d *DirPrint) EnterDir(name string) {
	fmt.Printf("%s+%s/\n", d.spaces(), name)
	d.depth++
}

func (d *DirPrint) ExitDir(name string) {
	d.depth--
}

func (d *DirPrint) DoFile(name string) {
	fmt.Printf("%s%s\n", d.spaces(), name)
}

//----------

// DirTreePrinter: output to stdout, as XML

type DirPrintXml struct {
	depth int
}

func (d *DirPrintXml) spaces() string {
	nbSpaces := d.depth * 3
	return strings.Repeat(" ", nbSpaces)
}

func (d *DirPrintXml) EnterDir(name string) {
	fmt.Printf("%s<dir name=\"%s\">\n", d.spaces(), html.EscapeString(name))
	d.depth++
}

func (d *DirPrintXml) ExitDir(name string) {
	d.depth--
	fmt.Printf("%s</dir>\n", d.spaces())
}

func (d *DirPrintXml) DoFile(name string) {
	fmt.Printf("%s<file>%s</file>\n", d.spaces(), html.EscapeString(name))
}

//----------

func main() {
	// read tree
	if tree, err := dirtree.New("/home/kwez/Videos"); err == nil {
		fmt.Println(tree)

		// output indented
		tree.Walk(&DirPrint{})

		// output as XML
		tree.Walk(&DirPrintXml{})

	} else {
		fmt.Println(err)
	}

}
