# epitech.kak

This plugin adds various [Epitech](http://epitech.eu/)-related utilities to Kakoune.
Note that while it is named "epitech.kak", there's no such file in the project tree, it's merely the plugin's name.

## Added keywords

 - option `realname` (type `str`): Contains the user's full name. Its default (global) value is the UNIX user's GECOS name.
 - option `epitech_login` (type `str`): Contains the user's Epitech login. Its default value is the UNIX username with "@epitech.eu" appended.
 - function `insert-epitech-header`: Puts an Epitech header at the beginning of the current buffer. Takes an (optional, see **Project Notes**) project name as first argument.
 - hidden function `update-epitech-header`: Updates the Epitech header in the current file, if found. You can use it manually, but that's not necessary.
 - hook group `epitech`: For now, it contains only a hook that's ran just before writing a buffer. The hook calls `update-epitech-header`.

## Dependencies

 - `coreutils`
 - `sed`
 - `project.kak` (optional, allows project name to be guessed and remembered) You can get it in this repository.

## Project Notes

Albeit `project.kak` is a purely optional dependency, it's heavily recommended to install it, as it will allow a buffer's project to be guessed (from Git, the main revision control system used at Epitech, or from the current directory).
And with the number of Epitech headers you make in your school life there, that's quite the time you save. If it's not installed, you'll have to pass a project name to `insert-epitech-header` every time.
