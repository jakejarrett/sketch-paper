using Gtk;

class PageView : Box {

	private Gtk.Box internal_box;

	private void show_preview (string preview_image) {
		this.preview_image = preview_image;
		var scroll = new ScrolledWindow (null, null);
		scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		Gtk.Image image = new Gtk.Image ();
		image.set_from_file (this.preview_image);
		scroll.add (image);

		this.pack_start (scroll, true, true, 0);
	}

	private void close_file () {
		var grid = new Gtk.Grid ();
		var data = new Gtk.Label ("Try opening a sketch file.");
		Gtk.Image image = new Gtk.Image ();
		grid.orientation = Gtk.Orientation.VERTICAL;
		grid.add (new image.from_icon_name ("face-embarrassed", Gtk.IconSize.DIALOG));
		grid.add (data);
		this.internal_box.pack_start (grid, true, true, 0);
	}
}
