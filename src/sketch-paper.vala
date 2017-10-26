using GLib;
using Json;
using Gtk;
using Gee;

class SketchPaper : Gtk.Application {

	private View view;

	/**
	 * Constructor
	 */
	public SketchPaper (Options options) {
		GLib.Object (application_id: "com.github.jakejarrett.sketch-paper", flags: ApplicationFlags.FLAGS_NONE);
		this.view = new View(options);
	}


	/**
	 * Start the application
	 */
	public static int main (string[] args) {
		Gtk.init (ref args);
		Options opts = new Options ();

		if (!opts.parse (ref args)) {
			return -1;
		}
		new SketchPaper(opts);
		Gtk.main ();

		return 0;
	}
}
