using Posix;
using GLib;

class ArchiveController : GLib.Object {

	private string file_destination = GLib.Environment.get_user_cache_dir () + "/sketch-paper/output";

	/**
	 * Read the sketch file.
	 */
	public void read_file (string file, PagesParser parser) {
		Posix.mkdir (this.file_destination, 0700);
		Posix.rmdir (this.file_destination + "/output/");
		Posix.chdir (this.file_destination);
		extract_file (file);
		parser.parse (this.file_destination);

	}
	
	[CCode (cname = "extract_file")]
	public static extern int extract_file (string filename);

	public string get_preview_image () {
		return this.file_destination + "/previews/preview.png";
	}

	public string get_output_directory () {
		return this.file_destination;
	}

}