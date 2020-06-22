[GtkTemplate (ui = "/com/bitstower/Markets/SymbolRow.ui")]
public class Markets.SymbolRow : Gtk.ListBoxRow {

    [GtkChild]
    Gtk.Label title;

    [GtkChild]
    Gtk.Label change;

    [GtkChild]
    Gtk.Label price;

    [GtkChild]
    Gtk.Label currency;

    [GtkChild]
    Gtk.Label details;

    public SymbolRow (string title, string price, string currency, string change) {
        Object ();

        this.title.label = title;
        this.change.label = change;
        this.price.label = price;
        this.currency.label = currency;
        this.details.label = "MARKET OPEN";
    }
}
