# project.kak

This plugin is very simple, all it does is add a `project` option.
This option is updated for each buffer at creation.
It takes either the Git repository's root name, or if that fails, the current directory's basename.

## Added keywords

 - option `project` (type `str`): Contains the current project's name. Should be only set at `buffer` scope. You can use `set` to override it.
 - function `guess-project`: Try to guess the current project's name. It's hooked to run at buffer creation.
 - hook group `project`: Its only hook is `guess-project` at buffer creation. It's just here so you can remove that.

## Optional dependencies 

 - `git` (Allow project name to be guessed from repository name)
