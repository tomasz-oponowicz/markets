[GtkTemplate (ui = "/com/bitstower/Markets/MainWindow.ui")]
public class Markets.MainWindow : Gtk.ApplicationWindow {

    [GtkChild]
    private Gtk.Stack stack;

    private Markets.State state;

    private Markets.MainHeaderBar main_header_bar;

    private Markets.SelectionHeaderBar selection_header_bar;

    public MainWindow (Gtk.Application app, Markets.State state) {
        Object (application: app);

        this.state = state;

        this.main_header_bar = new Markets.MainHeaderBar (this, state);
        this.selection_header_bar = new Markets.SelectionHeaderBar (state);
        this.set_titlebar (this.main_header_bar);

        var symbols_view = new Markets.SymbolsView (this.state);
        stack.add_named (symbols_view, "symbols_view");

        var no_symbols_view = new Markets.NoSymbolsView ();
        stack.add_named (no_symbols_view, "no_symbols_view");

        this.delete_event.connect (this.on_quit);
        this.state.notify["view-mode"].connect (this.on_selection_mode_update);
        this.state.notify["favourite-symbols"].connect (this.on_favourite_symbols_updated);
        this.on_favourite_symbols_updated ();

        this.window_position = Gtk.WindowPosition.CENTER;
        this.set_default_size (this.state.window_width, this.state.window_height);
    }

    private bool on_quit () {
        int width, height;
        this.get_size (out width, out height);

        this.state.window_width = width;
        this.state.window_height = height;

        return false;
    }

    private void on_favourite_symbols_updated () {
        if (this.state.favourite_symbols.size > 0) {
            this.stack.set_visible_child_name ("symbols_view");
        } else {
            this.stack.set_visible_child_name ("no_symbols_view");
        }
    }

    private void on_selection_mode_update () {
        switch (this.state.view_mode) {
            case Markets.ViewMode.PRESENTATION:
                this.set_titlebar (this.main_header_bar);
                break;
            case Markets.ViewMode.SELECTION:
                this.state.selection_mode = Markets.SelectionMode.NONE;
                this.set_titlebar (this.selection_header_bar);
                break;
        }
    }
}
