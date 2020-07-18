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

    [GtkChild]
    Gtk.CheckButton checkbox;

    private Symbol symbol;
    private Markets.State state;

    public SymbolRow (Symbol symbol, Markets.State state) {
        Object ();

        this.symbol = symbol;
        this.state = state;

        this.symbol.notify.connect (this.onSymbolUpdate);
        this.state.notify["viewMode"].connect (this.onViewModeUpdate);
        this.state.notify["selectionMode"].connect (this.onSelectionModeUpdate);

        this.onSymbolUpdate ();
        this.onViewModeUpdate ();
        this.onSelectionModeUpdate ();
    }

    private void onSymbolUpdate () {
        this.title.label = this.symbol.name;
        this.change.label = "%.2f".printf (this.symbol.regular_market_change);
        this.price.label = "%.2f".printf (this.symbol.regular_market_price);
        this.currency.label = "USD";
        this.details.label = "MARKET OPEN";
    }

    private void onViewModeUpdate () {
        this.checkbox.visible =
            this.state.viewMode == Markets.ViewMode.SELECTION;
    }

    private void onSelectionModeUpdate () {
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
    private void onCheckboxToggled () {
        if (this.checkbox.active) {
            this.symbol.selected = true;
            this.state.totalSelected++;
        } else {
            this.symbol.selected = false;
            this.state.totalSelected--;
        }
    }
}
