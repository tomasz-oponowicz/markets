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
    private Gtk.Label market;

    [GtkChild]
    private Gtk.Label time;

    [GtkChild]
    private Gtk.CheckButton checkbox;

    private Symbol symbol;
    private Markets.State state;

    public SymbolRow (Symbol symbol, Markets.State state) {
        Object ();

        this.symbol = symbol;
        this.state = state;

        this.symbol.notify.connect (this.on_symbol_update);
        this.state.notify["view-mode"].connect (this.on_view_mode_update);
        this.state.notify["selection-mode"].connect (this.on_selection_mode_update);

        this.on_symbol_update ();
        this.on_view_mode_update ();
        this.on_selection_mode_update ();
    }

    private void on_symbol_update () {
        int precision = this.symbol.precision;
        this.price.label = @"%'.$(precision)F".printf (this.symbol.regular_market_price);

        this.change.label =
            @"%'+.$(precision)F (%'+.2F)".printf (
                this.symbol.regular_market_change,
                this.symbol.regular_market_change_percent
            );

        var change_style = this.change.get_style_context ();
        change_style.remove_class ("profit");
        change_style.remove_class ("loss");
        if (this.symbol.regular_market_change >= 0) {
            change_style.add_class ("profit");
        } else {
            change_style.add_class ("loss");
        }

        var market_style = this.market.get_style_context ();
        market_style.remove_class ("open");
        market_style.remove_class ("dim-label");
        if (this.symbol.is_marked_closed) {
            this.market.label = "Market Closed";
            market_style.add_class ("dim-label");
        } else {
            this.market.label = "Market Open";
            market_style.add_class ("open");
        }

        this.title.label = this.symbol.name;
        this.currency.label = this.symbol.currency.up ();

        if (this.symbol.regular_market_time != null) {
            this.time.label = this.symbol.regular_market_time
                .to_local ()
                .format ("%b %e, %X");
        }
    }

    private void on_view_mode_update () {
        this.checkbox.visible =
            this.state.view_mode == Markets.ViewMode.SELECTION;
    }

    private void on_selection_mode_update () {
        switch (this.state.selection_mode) {
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
            this.state.total_selected++;
        } else {
            this.symbol.selected = false;
            this.state.total_selected--;
        }
    }
}
