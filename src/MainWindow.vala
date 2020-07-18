[GtkTemplate (ui = "/com/bitstower/Markets/MainWindow.ui")]
public class Markets.MainWindow : Gtk.ApplicationWindow {

    [GtkChild]
    Gtk.Stack stack;

    private Markets.State state;

    private Markets.MainHeaderBar main_header_bar;

    private Markets.SelectionHeaderBar selection_header_bar;

    private Markets.Service service;

    public MainWindow (Gtk.Application app, Markets.State state, Markets.Service service) {
        Object (application: app);

        this.state = state;
        this.service = service;

        this.main_header_bar = new Markets.MainHeaderBar (this, state, service);
        this.selection_header_bar = new Markets.SelectionHeaderBar (state);
        this.set_titlebar (this.main_header_bar);

        var view = new Markets.SymbolsView (this.state);
        stack.add_named (view, "symbols");
        stack.set_visible_child_name ("symbols");

        this.state.notify["viewMode"].connect (this.on_selection_mode_update);
    }

    private void on_selection_mode_update () {
        switch (this.state.viewMode) {
            case Markets.ViewMode.PRESENTATION:
                this.set_titlebar (this.main_header_bar);
                break;
            case Markets.ViewMode.SELECTION:
                this.state.selectionMode = Markets.SelectionMode.NONE;
                this.set_titlebar (this.selection_header_bar);
                break;
        }
    }
}
