app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import cli.Path
import cli.Stdout

Direc : [
    Filename Str,
    Direc { name : Str, subdirs : List Direc, files : List Direc },
]

# not exatly an implementation of the dirWalker pgm, close enough for now
main! = |_|
    Path.from_str "."
    |> read_dir!()?
    |> traverse!(0)?
    Ok {}

traverse! = |direc, depth|
    spaces = Str.repeat "  " depth
    when direc is
        Filename(name) ->
            Stdout.line!("${spaces}- ${name}")?

        Direc({ name, subdirs, files }) ->
            Stdout.line!("${spaces}+ ${name}/")?

            List.for_each!(subdirs, |d| Result.with_default(
                traverse!(d, depth+1), {})
            )

            # NB: craches if I use List.for_each!(files, |f| …
            List.for_each!(files, |Filename f| Result.with_default(
                traverse!(Filename f, depth+1), {})
            )
    Ok {}


read_dir! = |path|
    kids = Path.list_dir!(path)?
    files = get_files!(kids)?
    subdirPaths = get_dirs!(kids)?
    subdirs = List.map_try!(subdirPaths, |p| read_dir!(p))?

    Ok Direc( { name: Path.display path, subdirs: subdirs, files: files } )

get_files! = |kids_path|
    Ok(
        kids_path
        |> List.keep_if_try!(Path.is_file!)?
        |> List.map Path.display
        |> List.map Filename,
    )

get_dirs! = |kids_path|
    Ok List.keep_if_try!(kids_path, Path.is_dir!)?
