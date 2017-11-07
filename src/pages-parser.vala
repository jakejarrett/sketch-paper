using GLib;
using Posix;

/**
 * Options parser for the command line
 */
public class PagesParser : GLib.Object {

	private string document = "";
	private string meta_file = "";

	private string read_file (string file) {
		var file_instance = File.new_for_path (file);
		string json_file = "";

		try {
			FileInputStream @is = file_instance.read ();
			DataInputStream dis = new DataInputStream (@is);
			string line;
	
			while ((line = dis.read_line ()) != null) {
				json_file = line;
			}
		} catch (Error e) {
			Posix.stderr.printf ("Error: %s\n", e.message);
		}

		return json_file;
	}

	public void read_page (string page) {
		string file = this.read_file (page);
		Json.Parser parser = new Json.Parser ();

		try {
			parser.load_from_data (file);
			var root_object = parser.get_root ().get_object ();
			string page_name = this.get_page_name (root_object.get_string_member ("do_objectID"));
			Posix.stdout.printf ("\n%s\n", page_name);
		} catch (Error e) {
			Posix.stderr.printf ("Error: %s\n", e.message);
		}
	}

	private string get_page_name (string page) {
		var parser = new Json.Parser ();
		string return_value = "";
		
		try {
			parser.load_from_data (this.meta_file);
			
			var root_object = parser.get_root ().get_object ();
			var pages = root_object.get_object_member ("pagesAndArtboards");
			var page_object = pages.get_object_member (page);

			Posix.stdout.printf ("\n%s\n", page);

			return_value = page_object.get_string_member ("name");
		} catch (Error e) {
			Posix.stderr.printf ("Error: %s\n", e.message);
		}

		return return_value;
	}

	public void parse (string file_directory) {
		var parser = new Json.Parser ();
		this.document = this.read_file (file_directory + "/document.json");
		this.meta_file = this.read_file (file_directory + "/meta.json");

		try {
			parser.load_from_data (this.document);
			var root_object = parser.get_root ().get_object ();
			var pages = root_object.get_array_member ("pages");
	
			foreach (var page in pages.get_elements ()) {
				var page_name = page.get_object ();
				this.read_page (file_directory + "/" + page_name.get_string_member ("_ref") + ".json");
			}
		} catch (Error e) {
			Posix.stderr.printf ("Error: %s\n", e.message);
		}
	}
}