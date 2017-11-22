using Gtk;

public class Sidebar : Grid {

    private Gtk.Stack stack_instance;
    private const int TRANSITION_DURATION_MILLISECONDS = 300;

    public void Sidebar () {
        var stacksidebar = new StackSidebar();
        this.attach(stacksidebar, 0, 0, 1, 1);

        var stack = new Stack();
        stack.set_vexpand(true);
        stack.set_hexpand(true);
        stacksidebar.set_stack(stack);
        this.attach(stack, 1, 0, 1, 1);

        var label1 = new Label("Page 1 of Stack");
        stack.add_titled(label1, "Page1", "Page 1");

        var label2 = new Label("Page 2 of Stack");
        stack.add_titled(label2, "Page2", "Page 2");
    }

    public void show_list (string output_dir, PagesParser parser) {
        //  foreach (string page in parser.list) {
        //      Gtk.Label label = new Gtk.Label (page);
        //      label.get_style_context ().add_class ("h1");
        //      name_label.xalign = 0;
        //      name_label.use_markup = true;
        //      name_label.wrap = true;
        //      name_label.max_width_chars = 50;

        //      this.pack_start (label, false, false, 0);
        //  }

        //  this.show_all ();
    }

    public void show_empty () {
        //  Gtk.Label label = new Gtk.Label ("No data");
        //  this.pack_start (label, false, false, 0);

        //  this.show_all ();
    }
}