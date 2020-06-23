[GtkTemplate (ui = "/com/bitstower/Markets/MainWindow.ui")]
public class Markets.MainWindow : Gtk.ApplicationWindow {

	[GtkChild]
	Gtk.Stack stack;

	private Markets.State state;

	private Markets.MainHeaderBar mainHeaderBar;

	private Markets.SelectionHeaderBar selectionHeaderBar;

	public MainWindow (Gtk.Application app) {
        Object (application: app);

        this.state = new Markets.State ();

        this.mainHeaderBar = new Markets.MainHeaderBar (this, state);
        this.selectionHeaderBar = new Markets.SelectionHeaderBar (state);
	    this.set_titlebar (this.mainHeaderBar);

        var view = new Markets.SymbolsView (this.state);
        stack.add_named(view, "symbols");
	    stack.set_visible_child_name("symbols");

	    this.state.notify["viewMode"].connect (this.onSelectionModeUpdate);
	}

	private void onSelectionModeUpdate () {
	    if (this.state.viewMode == Markets.ViewMode.PRESENTATION) {
	        this.set_titlebar (this.mainHeaderBar);
	    } else {
	        this.set_titlebar (this.selectionHeaderBar);
	    }
	}
}
