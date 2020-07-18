using Gee;

[GtkTemplate (ui = "/com/bitstower/Markets/SelectionHeaderBar.ui")]
public class Markets.SelectionHeaderBar : Hdy.HeaderBar {

    [GtkChild]
    Gtk.Button deleteBtn;

    private Markets.State state;

    public SelectionHeaderBar (Markets.State state) {
        Object ();

        this.state = state;

        this.state.notify["totalSelected"].connect (this.onTotalSelectedUpdated);

        this.onTotalSelectedUpdated ();
    }

    [GtkCallback]
    private void onCancelClicked () {
        this.state.viewMode = Markets.ViewMode.PRESENTATION;
    }

    [GtkCallback]
    private void onDeleteClicked () {
        var filtered = new ArrayList<Symbol> ();

        foreach (Symbol symbol in this.state.favourite_symbols) {
            if (!symbol.selected) {
                filtered.add (symbol);
            }
        }

        // create new array in order to enforce a notification
        this.state.favourite_symbols = filtered;
    }

    private void onTotalSelectedUpdated () {
        this.deleteBtn.sensitive = this.state.totalSelected > 0;
    }
}
