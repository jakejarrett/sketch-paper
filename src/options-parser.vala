using GLib;

/**
 * Options parser for the command line
 */
public class Options : GLib.Object {

	public string option_output = "";

	/**
	 * Parse the CLI options.
	 */
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