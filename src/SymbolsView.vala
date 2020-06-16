[GtkTemplate (ui = "/com/bitstower/Markets/SymbolsView.ui")]
public class Markets.SymbolsView : Gtk.ScrolledWindow {

    [GtkChild]
    Gtk.ListBox symbols;

    public SymbolsView () {
        Object ();

        symbols.add(new Markets.SymbolRow ("TESLA", "9545,54", "USD", "+30 (+2.5%)"));
        symbols.add(new Markets.SymbolRow ("GOOG", "1400,54", "USD", "+10 (+3.3%)"));
        symbols.add(new Markets.SymbolRow ("BTC/EUR", "8431,20", "EUR", "+111 (+1.2%)"));
    }
}
