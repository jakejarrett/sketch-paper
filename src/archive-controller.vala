using Posix;
using GLib;

class ArchiveController : GLib.Object {

	private string file_destination = GLib.Environment.get_user_cache_dir () + "/sketch-paper/output";

	/**
	 * Read the sketch file.
	 */
	public void read_file (string file) {
		Posix.rmdir (this.file_destination);
		Posix.mkdir (this.file_destination, 0700);
		Posix.chdir (this.file_destination);
		extract_file (file);
	}
	
	[CCode (cname = "extract_file")]
	public static extern int extract_file (string filename);

	public string get_preview_image () {
		return this.file_destination + "/previews/preview.png";
	}

}