using GLib;
using Archive;

class ArchiveController : GLib.Object {

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
	public void read_file (string file) {
		try {
			var archiveRead = new Archive.Read ();
			this.check_ok (archiveRead.support_filter_all ());
			this.check_ok (archiveRead.support_format_all ());
			this.check_ok (archiveRead.open_filename (file, 10240));
	
			unowned Archive.Entry entry;

			while (archiveRead.next_header (out entry) == Archive.Result.OK) {
				stdout.printf ("%s\n", entry.pathname ());
				archiveRead.read_data_skip ();
			}

		} catch (IOError e) {
			stderr.printf (e.message + "\n");
		}
	}

}