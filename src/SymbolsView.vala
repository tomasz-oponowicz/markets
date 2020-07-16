[GtkTemplate (ui = "/com/bitstower/Markets/SymbolsView.ui")]
public class Markets.SymbolsView : Gtk.ScrolledWindow {

    [GtkChild]
    Gtk.ListBox symbols;

    private Markets.State state;

    public SymbolsView (Markets.State state) {
        Object ();

        this.state = state;

        this.state.notify["favourite-symbols"].connect (this.onFavouriteSymbolsUpdate);
        this.onFavouriteSymbolsUpdate ();
    }

    private void onFavouriteSymbolsUpdate () {
        var children = this.symbols.get_children ();
        foreach (Gtk.Widget widget in children) {
            this.symbols.remove (widget);
        }

        foreach (Symbol symbol in this.state.favourite_symbols) {
            symbols.add(new Markets.SymbolRow (symbol, state));
        }
    }
}
