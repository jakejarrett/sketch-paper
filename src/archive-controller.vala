using Posix;
using GLib;
using Archive;

class ArchiveController : GLib.Object {

	private string file_destination = GLib.Environment.get_user_cache_dir () + "/sketch-paper/output";
	private Archive.Read archive_read;
	private Archive.WriteDisk archive_write;

	/**
	 * Check if the sketch archive is okay before proceeding.
	 */
	private void check_ok (Archive.Result r) throws IOError {
		if (r == Archive.Result.FAILED) {
			throw new IOError.FAILED ("libarchive returned an error");
		}
	}

	/**
	 * Read the sketch file.
	 */
	public void read_file (string file) {
		this.archive_read = new Archive.Read ();
		this.archive_write = new Archive.WriteDisk ();
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