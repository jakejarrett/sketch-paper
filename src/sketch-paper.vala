using GLib;
using Json;
using Gtk;
using Archive;

/**
 * Options parser for the command line
 */
public class Options : GLib.Object {
	
	public string option_output = "";

	public bool parse (ref unowned string[] args) {
		bool result = true;
		var options = new OptionEntry[2];
		options[0] = { "file", 'f', 0, OptionArg.FILENAME, ref option_output, "file name for sketch file (required);", "FILE" };
		options[1] = {null};

		var opt_context = new OptionContext ("- USketch");
		opt_context.set_help_enabled (true);
		opt_context.add_main_entries (options, null);

		try {
			opt_context.parse (ref args);
		} catch {
			result = false;
		}

		if (result && "" != this.option_output && !(".sketch" in this.option_output)) {
			result = false;
		}

		return result;
	}

}

class USketch : Window {
	
	private HeaderBar headerbar;
	private string file;

	/**
	 * Setup the main interface & determine if we should show an "Open" state.
	 */
	public USketch (Options options) {
		if (options.option_output != "") {
			this.file = options.option_output;
			this.read_file ();
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
		this.headerbar.title = "USketch";

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
		this.add (grid);
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
			this.read_file ();
			this.on_open_file ();
			this.show_all ();
		}

		file_chooser.destroy ();
	}

	/**
	 * When the file is opened, we'll update state here.
	 */
	private void on_open_file () {
		this.headerbar.subtitle = this.file;
	}

	/**
	 * Check if the sketch archive is okay before proceeding.
	 */
	private void check_ok (Archive.Result r) throws IOError {
		if (r == Archive.Result.OK) {
			return;
		}
		if (r == Archive.Result.WARN) {
			return;
		}

		throw new IOError.FAILED ("libarchive returned an error");
	}

	/**
	 * Read the sketch file.
	 */
	private void read_file () {
		try {
			var archiveRead = new Archive.Read ();
			this.check_ok (archiveRead.support_filter_all ());
			this.check_ok (archiveRead.support_format_all ());
			this.check_ok (archiveRead.open_filename (this.file, 10240));
	
			unowned Archive.Entry entry;

			while (archiveRead.next_header (out entry) == Archive.Result.OK) {
				stdout.printf ("%s\n", entry.pathname ());
				archiveRead.read_data_skip ();
			}

		} catch (IOError e) {
			stderr.printf (e.message + "\n");
		}
	}

	public static int main (string[] args) {
		Gtk.init (ref args);
		Options opts = new Options ();

		if (!opts.parse (ref args)) {
			return -1;
		}

		new USketch(opts);
		Gtk.main ();

		return 0;
	}

}
