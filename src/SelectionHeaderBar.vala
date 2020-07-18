using Gee;

[GtkTemplate (ui = "/com/bitstower/Markets/SelectionHeaderBar.ui")]
public class Markets.SelectionHeaderBar : Hdy.HeaderBar {

    [GtkChild]
    private Gtk.Button delete_button;

    private Markets.State state;

    public SelectionHeaderBar (Markets.State state) {
        Object ();

        this.state = state;

        this.state.notify["totalSelected"].connect (this.on_total_selected_updated);

        this.on_total_selected_updated ();
    }

    [GtkCallback]
    private void on_cancel_clicked () {
        this.state.viewMode = Markets.ViewMode.PRESENTATION;
    }

    [GtkCallback]
    private void on_delete_clicked () {
        var filtered = new ArrayList<Symbol> ();

        foreach (Symbol symbol in this.state.favourite_symbols) {
            if (!symbol.selected) {
                filtered.add (symbol);
            }
        }

        // create new array in order to enforce a notification
        this.state.favourite_symbols = filtered;
    }

    private void on_total_selected_updated () {
        this.delete_button.sensitive = this.state.totalSelected > 0;
    }
}
