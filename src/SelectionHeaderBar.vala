[GtkTemplate (ui = "/biz/zaxo/Markets/SelectionHeaderBar.ui")]
public class Markets.SelectionHeaderBar : Hdy.HeaderBar {

    [GtkChild]
    private Gtk.Button delete_button;

    [GtkChild]
    private Gtk.Button cancel_button;

    private State state;

    public SelectionHeaderBar (MainWindow window, State state) {
        this.state = state;

        this.state.notify["has-selected"].connect (this.on_has_selected_updated);

        this.on_has_selected_updated ();

        this.cancel_button.add_accelerator (
            "clicked",
            window.accel_group,
            Gdk.Key.Escape,
            0,
            Gtk.AccelFlags.VISIBLE
        );
    }

    [GtkCallback]
    private void on_cancel_clicked () {
        this.state.view_mode = State.ViewMode.PRESENTATION;
    }

    [GtkCallback]
    private void on_delete_clicked () {
        Gee.ArrayList<string> ids = new Gee.ArrayList<string> ();
        foreach (Symbol symbol in this.state.symbols) {
            if (symbol.selected) {
                ids.add (symbol.id);
            }
        }

        this.state.remove_symbols (ids);
    }

    private void on_has_selected_updated () {
        this.delete_button.sensitive = this.state.has_selected;
    }
}
