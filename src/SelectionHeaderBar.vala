using Gee;

[GtkTemplate (ui = "/com/bitstower/Markets/SelectionHeaderBar.ui")]
public class Markets.SelectionHeaderBar : Hdy.HeaderBar {

    [GtkChild]
    private Gtk.Button delete_button;

    private Markets.State state;

    public SelectionHeaderBar (Markets.State state) {
        Object ();

        this.state = state;

        this.state.notify["total-selected"].connect (this.on_total_selected_updated);

        this.on_total_selected_updated ();
    }

    [GtkCallback]
    private void on_cancel_clicked () {
        this.state.view_mode = State.ViewMode.PRESENTATION;
    }

    [GtkCallback]
    private void on_delete_clicked () {
        ArrayList<string> ids = new ArrayList<string> ();
        foreach (Symbol symbol in this.state.symbols) {
            if (symbol.selected) {
                ids.add (symbol.id);
            }
        }

        this.state.remove_symbols (ids);
    }

    private void on_total_selected_updated () {
        this.delete_button.sensitive = this.state.total_selected > 0;
    }
}
