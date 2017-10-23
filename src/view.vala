using Gtk;

class View : Window {

	private HeaderBar headerbar;
	private string file;
	private string window_title = "Sketch Paper";
	private string preview_image;
	private ArchiveController achive_controller;

	/**
	 * Setup the main interface & determine if we should show an "Open" state.
	 */
	public View (Options options) {
		this.achive_controller = new ArchiveController();

		if (options.option_output != "") {
			this.file = options.option_output;
			this.achive_controller.read_file (this.file);
			this.preview_image = this.achive_controller.get_preview_image ();
		}

		this.headerbar = new Gtk.HeaderBar ();
		this.setup_headerbar ();
		this.setup_grid ();

		this.show_all ();
		this.destroy.connect (Gtk.main_quit);
	}

	/**
	 * Setup the headerbar.
	 */
	private void setup_headerbar () {
		this.headerbar.title = this.window_title;

		var open_button = new Gtk.Button.with_label ("Open");
		open_button.set_valign (Gtk.Align.CENTER);
		open_button.clicked.connect (on_open_clicked);		
		this.headerbar.pack_start (open_button);

		this.headerbar.show_close_button = true;

		if (this.file != "" && ".sketch" in this.file) {
			this.on_open_file ();
		}
		
		this.window_position = WindowPosition.CENTER;
		this.set_default_size (800, 600);
		this.set_titlebar (this.headerbar);
	}

	/**
	 * Setup the Grid interface.
	 */
	private void setup_grid () {
		var grid = new Gtk.Grid ();
		var label_one = new Gtk.Label ("Label 1");
		var label_two = new Gtk.Label ("Label 2");
		grid.orientation = Gtk.Orientation.HORIZONTAL;
		grid.add (label_one);
		grid.add (label_two);
		
		if (this.preview_image != "") {
			Gtk.Image image = new Gtk.Image ();
			image.set_from_file (this.preview_image);
			grid.add (image);
		}

		this.add (grid);
	}

	/**
	 * When the user clicks the Open button in the headerbar.
	 * 
	 * TODO- Move the archive/unarchive logic to a controller.
	 */
	private void on_open_clicked () {
		var file_chooser = new FileChooserDialog ("Open File", this,
			FileChooserAction.OPEN,
			"_Cancel",
			ResponseType.CANCEL,
			"_Open",
			ResponseType.ACCEPT
		);

		Gtk.FileFilter filter = new Gtk.FileFilter ();
		file_chooser.set_filter (filter);
		filter.add_pattern ("*.sketch");

		if (file_chooser.run () == ResponseType.ACCEPT) {
			this.file = file_chooser.get_filename ();
			file_chooser.destroy ();
			this.achive_controller.read_file (this.file);
			this.on_open_file ();
			this.show_all ();
		}
	}

	/**
	 * When the file is opened, we'll update state here.
	 */
	private void on_open_file () {
		this.headerbar.subtitle = this.file;
		this.preview_image = this.achive_controller.get_preview_image ();
	}
}
