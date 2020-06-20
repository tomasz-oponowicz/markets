[GtkTemplate (ui = "/com/bitstower/Markets/window.ui")]
public class Markets.Window : Gtk.ApplicationWindow {

	[GtkChild]
	Gtk.Stack stack;

	public Window (Gtk.Application app) {
        Object (application: app);

	    this.set_titlebar (new Markets.HeaderBar (this));

        var view = new Markets.SymbolsView ();
        stack.add_named(view, "symbols");
	    stack.set_visible_child_name("symbols");
	}
}
