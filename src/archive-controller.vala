using Posix;
using GLib;
using Archive;

class ArchiveController : GLib.Object {

	private string file_destination = GLib.Environment.get_user_cache_dir () + "/sketch-paper/output";

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

		if (r == Archive.Result.EOF) {
			return;
		}

		if (r == Archive.Result.RETRY) {
			return;
		}

		if (r == Archive.Result.FAILED) {
			throw new IOError.FAILED ("libarchive returned an error");
		}
	}

	/**
	 * Read the sketch file.
	 */
	public void read_file (string file) {
		try {
			var archive_read = new Archive.Read ();
			var archive_write = new Archive.Write ();
			this.check_ok (archive_read.support_filter_all ());
			this.check_ok (archive_read.support_format_all ());
			this.check_ok (archive_read.open_filename (file, 10240));
			Posix.mkdir (this.file_destination, 0700);
			Posix.chdir (this.file_destination);
			
			unowned Archive.Entry entry;

			while (archive_read.next_header (out entry) == Archive.Result.OK) {
				entry.set_pathname (this.file_destination + "/" + entry.pathname ());
				archive_write.write_header (entry);
				GLib.stdout.printf (entry.pathname () + "\n");
				archive_read.read_data_skip ();
			}

		} catch (IOError e) {
			GLib.stderr.printf (e.message + "\n");
		}
	}

	public string get_preview_image () {
		return this.file_destination + "/previews/preview.png";
	}

}