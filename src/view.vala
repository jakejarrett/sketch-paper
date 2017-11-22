using Gtk;

class View : Window {

	private HeaderBar headerbar;
	private string file;
	private string window_title = "Sketch Paper";
	private string preview_image = "";
	private ArchiveController archive_controller;
	private Box vbox;
	private Sidebar sidebar;
	private PageView page_view;
	public PagesParser pages_parser;

	/**
	 * Setup the main interface & determine if we should show an "Open" state.
	 */
	public View (Options options) {
		this.archive_controller = new ArchiveController ();
		this.pages_parser = new PagesParser ();
		this.page_view = new PageView (Orientation.HORIZONTAL, 0);

		if (options.option_output != "") {
			this.file = options.option_output;
			this.archive_controller.read_file (this.file, this.pages_parser);
			this.preview_image = this.archive_controller.get_preview_image ();
		}

		this.headerbar = new Gtk.HeaderBar ();
		this.setup_headerbar ();
		this.setup_grid ();
		this.show_all ();
		this.destroy.connect (Gtk.main_quit);
		key_press_event.connect (on_key_pressed);
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
		this.sidebar = new Sidebar();

		//  this.vbox.set_homogeneous (false);

		if (this.preview_image != "") {
			this.sidebar.show_list (this.archive_controller.get_output_directory (), this.pages_parser);
			this.vbox.pack_start (this.sidebar, false, false, 10);

			this.page_view.show_preview (this.preview_image);
			
			this.vbox.pack_end (this.page_view, true, true, 0);
		} else {
			this.sidebar.show_empty ();
			this.vbox.pack_start(this.sidebar, false, false, 10);
			var grid = new Gtk.Grid ();
			var data = new Gtk.Label ("Try opening a sketch file.");
			Gtk.Image image = new Gtk.Image ();
			grid.orientation = Gtk.Orientation.VERTICAL;
			grid.add (new image.from_icon_name ("face-embarrassed", Gtk.IconSize.DIALOG));
			grid.add (data);
			this.vbox.pack_end (grid, true, true, 0);
		}
	}

	public void open_file () {
		this.on_open_clicked ();
	}

	/**
	 * When the user clicks the Open button in the headerbar.
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
			this.archive_controller.read_file (this.file, this.pages_parser);
			this.on_open_file ();
			this.show_all ();
		}
	}

	/**
	 * When the file is opened, we'll update state here.
	 */
	private void on_open_file () {
		this.headerbar.subtitle = this.file;
		this.preview_image = this.archive_controller.get_preview_image ();
		this.remove (this.vbox);
		this.setup_box ();
		this.show_all ();
	}

	private void close_file () {
		this.file = "";
		this.headerbar.subtitle = this.file;
		this.preview_image = "";
		this.remove (this.vbox);
		this.setup_box ();
		this.show_all ();
	}

	private bool on_key_pressed (Gdk.EventKey event) {
		string key = Gdk.keyval_name (event.keyval);

		if (key == "o" && (event.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
			this.open_file ();
			return true;
		}

		if (key == "w" && (event.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
			this.close_file ();
			return true;
		}

		return false;
	}
}
