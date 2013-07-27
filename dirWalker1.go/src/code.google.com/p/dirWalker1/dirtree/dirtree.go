// dirtree.go
// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0
package dirtree

import "io/ioutil"
import "path"

// definition of DirTree, holds the directory structure
type DirTree struct {
	name  string
	kids  []*DirTree
	files []string
}

// interface to implement to print the dirs/files of DirTree (DirTree.Walk())
type DirTreePrinter interface {
	EnterDir(name string)
	ExitDir(name string)
	DoFile(name string)
}

//----------

// Create a DirTree from top
func New(dirpath string) (*DirTree, error) {
	tree := &DirTree{}

	if err := tree.read(dirpath); err != nil {
		return nil, err
	}

	return tree, nil
}

//----------

// traverse DirTree, calling the DirTreePrinter on dirs / files
func (tree *DirTree) Walk(printer DirTreePrinter) {
	if tree != nil {
		printer.EnterDir(tree.name)

		for _, kid := range tree.kids {
			kid.Walk(printer)
		}

		for _, file := range tree.files {
			printer.DoFile(file)
		}

		printer.ExitDir(tree.name)
	}
}

//----------

// read recursively the directory, creating DirTrees
func (tree *DirTree) read(dirpath string) error {
	// get base name ie "subdir1"
	tree.name = path.Base(dirpath)

	// read directory
	dirEntries, err := ioutil.ReadDir(dirpath)
	if err != nil {
		return err
	}

	// process entries, file or subdir
	for _, v := range dirEntries {
		if v.IsDir() {
			// recurse, read subdir
			kid, err := New(path.Join(dirpath, v.Name()))
			if err != nil {
				return err
			}
			tree.kids = append(tree.kids, kid)
		} else {
			tree.files = append(tree.files, v.Name())
		}
	}

	return nil // no error
}
