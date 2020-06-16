[GtkTemplate (ui = "/com/bitstower/Markets/SymbolRow.ui")]
public class Markets.SymbolRow : Gtk.ListBoxRow {


    [GtkChild]
    Gtk.Label name;

    [GtkChild]
    Gtk.Label change;

    [GtkChild]
    Gtk.Label price;

    [GtkChild]
    Gtk.Label currency;

    [GtkChild]
    Gtk.Label details;

    public SymbolRow (string name, string price, string currency, string change) {
        Object ();

        this.name.label = name;
        this.change.label = change;
        this.price.label = price;
        this.currency.label = currency;
        this.details.label = "MARKET OPEN";
    }
}
