[GtkTemplate (ui = "/com/bitstower/Markets/MainWindow.ui")]
public class Markets.MainWindow : Hdy.ApplicationWindow {

    [GtkChild]
    private Gtk.Stack stack;

    [GtkChild]
    private Gtk.Box titlebar;

    private State state;

    private MainHeaderBar main_header_bar;

    private SelectionHeaderBar selection_header_bar;

    public Gtk.AccelGroup accel_group;

    public MainWindow (Gtk.Application app, State state) {
        Object (
            application: app,
            icon_name: Constants.APP_ID,
            title: _("Markets")
        );

        this.accel_group = new Gtk.AccelGroup();
        this.add_accel_group(accel_group);

        this.state = state;

        this.main_header_bar = new MainHeaderBar (this, state);

        this.selection_header_bar = new SelectionHeaderBar (state);
        this.selection_header_bar.visible = false;

        this.titlebar.pack_start (this.main_header_bar, false);
        this.titlebar.pack_start (this.selection_header_bar, false);

        var symbols_view = new SymbolsView (this.state);
        stack.add_named (symbols_view, "symbols_view");

        var no_symbols_view = new NoSymbolsView ();
        stack.add_named (no_symbols_view, "no_symbols_view");

        this.delete_event.connect (this.on_quit);
        this.state.notify["view-mode"].connect (this.on_selection_mode_update);
        this.state.notify["symbols"].connect (this.on_symbols_updated);
        this.on_symbols_updated ();

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

    private void on_symbols_updated () {
        if (this.state.symbols.size > 0) {
            this.stack.set_visible_child_name ("symbols_view");
        } else {
            this.stack.set_visible_child_name ("no_symbols_view");
        }
    }

    private void on_selection_mode_update () {
        switch (this.state.view_mode) {
            case State.ViewMode.PRESENTATION:
                this.selection_header_bar.visible = false;
                this.main_header_bar.visible = true;
                break;
            case State.ViewMode.SELECTION:
                this.state.select_none ();
                this.selection_header_bar.visible = true;
                this.main_header_bar.visible = false;
                break;
        }
    }
}
