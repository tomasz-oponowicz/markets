[GtkTemplate (ui = "/com/bitstower/Markets/SymbolRow.ui")]
public class Markets.SymbolRow : Gtk.ListBoxRow {

    [GtkChild]
    private Gtk.Label title;

    [GtkChild]
    private Gtk.Label change;

    [GtkChild]
    private Gtk.Label price;

    [GtkChild]
    private Gtk.Label currency;

    [GtkChild]
    private Gtk.Label details;

    [GtkChild]
    private Gtk.CheckButton checkbox;

    private Symbol symbol;
    private Markets.State state;

    public SymbolRow (Symbol symbol, Markets.State state) {
        Object ();

        this.symbol = symbol;
        this.state = state;

        this.symbol.notify.connect (this.on_symbol_update);
        this.state.notify["viewMode"].connect (this.on_view_mode_update);
        this.state.notify["selectionMode"].connect (this.on_selection_mode_update);

        this.on_symbol_update ();
        this.on_view_mode_update ();
        this.on_selection_mode_update ();
    }

    private void on_symbol_update () {
        this.title.label = this.symbol.name;
        this.change.label = "%.2f".printf (this.symbol.regular_market_change);
        this.price.label = "%.2f".printf (this.symbol.regular_market_price);
        this.currency.label = "USD";
        this.details.label = "MARKET OPEN";
    }

    private void on_view_mode_update () {
        this.checkbox.visible =
            this.state.viewMode == Markets.ViewMode.SELECTION;
    }

    private void on_selection_mode_update () {
        switch (this.state.selectionMode) {
            case Markets.SelectionMode.ALL:
                this.symbol.selected = true;
                this.checkbox.active = true;
                break;
            case Markets.SelectionMode.NONE:
                this.symbol.selected = false;
                this.checkbox.active = false;
                break;
        }
    }

    [GtkCallback]
    private void on_checkbox_toggled () {
        if (this.checkbox.active) {
            this.symbol.selected = true;
            this.state.totalSelected++;
        } else {
            this.symbol.selected = false;
            this.state.totalSelected--;
        }
    }
}
