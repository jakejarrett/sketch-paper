* JSON-GLib (Reading the JSON files from sketch)
* GIO 2.0 (Reading files)
* libarchive (Opening sketch files)
* clutter (Renderer for sketch pages / artboards)
* libgee-0.8-dev

valac --thread --pkg json-glib-1.0 --pkg libarchive --pkg gio-2.0 <filename>.vala
