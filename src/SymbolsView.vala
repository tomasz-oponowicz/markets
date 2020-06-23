[GtkTemplate (ui = "/com/bitstower/Markets/SymbolsView.ui")]
public class Markets.SymbolsView : Gtk.ScrolledWindow {

    [GtkChild]
    Gtk.ListBox symbols;

    private Markets.State state;

    public SymbolsView (Markets.State state) {
        Object ();

        this.state = state;

        symbols.add(new Markets.SymbolRow ("TESLA", "9545.54", "USD", "+30 (+2.5%)", state));
        symbols.add(new Markets.SymbolRow ("GOOG", "1400.54", "USD", "+10 (+3.3%)", state));
        symbols.add(new Markets.SymbolRow ("BTC/EUR", "8433.20", "EUR", "+111 (+1.2%)", state));
    }
}
