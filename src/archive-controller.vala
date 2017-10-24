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
		this.extract_file (file);
	}

	private void copy_data () {
		void *buff;
		size_t size;
		Posix.off_t offset = 0;

		this.archive_read.read_data_block (out buff, out size, out offset);
		this.archive_write.write_data_block (buff, size, offset);
		this.archive_write.finish_entry ();
	}
	

	private void extract_file (string file) {
		try {
			this.check_ok (this.archive_read.support_filter_all ());
			this.check_ok (this.archive_read.support_format_all ());
			this.check_ok (this.archive_read.open_filename (file, 102400));

			unowned Archive.Entry entry;
			while (this.archive_read.next_header (out entry) == Archive.Result.OK) {
				entry.set_pathname (this.file_destination + "/" + entry.pathname ());
				entry.set_size (entry.size ());
				entry.set_filetype (0700);
				entry.set_perm (0644);
				this.archive_write.set_standard_lookup ();
				this.archive_write.set_standard_lookup ();
				this.archive_write.write_header (entry);

				this.copy_data ();
			}

			if (this.archive_read.next_header (out entry) == Archive.Result.EOF) {
				this.archive_read.close ();
				this.archive_write.close ();
			}
		} catch (IOError e) {
			GLib.stderr.printf (e.message + "\n");
		}
	}

	public string get_preview_image () {
		return this.file_destination + "/previews/preview.png";
	}

}