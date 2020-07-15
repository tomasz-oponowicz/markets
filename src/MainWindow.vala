[GtkTemplate (ui = "/com/bitstower/Markets/MainWindow.ui")]
public class Markets.MainWindow : Gtk.ApplicationWindow {

	[GtkChild]
	Gtk.Stack stack;

	private Markets.State state;

	private Markets.MainHeaderBar mainHeaderBar;

	private Markets.SelectionHeaderBar selectionHeaderBar;

	private Markets.Service service;

	public MainWindow (Gtk.Application app, Markets.State state, Markets.Service service) {
    Object (application: app);

    this.state = state;
    this.service = service;

    this.mainHeaderBar = new Markets.MainHeaderBar (this, state, service);
    this.selectionHeaderBar = new Markets.SelectionHeaderBar (state);
    this.set_titlebar (this.mainHeaderBar);

    var view = new Markets.SymbolsView (this.state);
    stack.add_named(view, "symbols");
    stack.set_visible_child_name("symbols");

    this.state.notify["viewMode"].connect (this.onSelectionModeUpdate);
	}

	private void onSelectionModeUpdate () {
	    switch (this.state.viewMode) {
	        case Markets.ViewMode.PRESENTATION:
	            this.set_titlebar (this.mainHeaderBar);
	            break;
            case Markets.ViewMode.SELECTION:
	            this.state.selectionMode = Markets.SelectionMode.NONE;
	            this.set_titlebar (this.selectionHeaderBar);
	            break;
	    }
	}
}
