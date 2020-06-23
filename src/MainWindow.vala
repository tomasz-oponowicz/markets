[GtkTemplate (ui = "/com/bitstower/Markets/MainWindow.ui")]
public class Markets.MainWindow : Gtk.ApplicationWindow {

	[GtkChild]
	Gtk.Stack stack;

	private Markets.Model model;

	private Markets.MainHeaderBar mainHeaderBar;

	private Markets.SelectionHeaderBar selectionHeaderBar;

	public MainWindow (Gtk.Application app) {
        Object (application: app);

        this.model = new Markets.Model ();

        this.mainHeaderBar = new Markets.MainHeaderBar (this, model);
        this.selectionHeaderBar = new Markets.SelectionHeaderBar (model);
	    this.set_titlebar (this.mainHeaderBar);

        var view = new Markets.SymbolsView ();
        stack.add_named(view, "symbols");
	    stack.set_visible_child_name("symbols");

	    this.model.notify["selectionEnabled"].connect (this.onSelectionEnabledUpdate);
	}

	private void onSelectionEnabledUpdate () {
	    if (this.model.selectionEnabled) {
            this.set_titlebar (this.selectionHeaderBar);
	    } else {
	        this.set_titlebar (this.mainHeaderBar);
	    }
	}
}
