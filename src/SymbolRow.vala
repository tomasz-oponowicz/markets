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

    private State state;

    private Symbol symbol;

    public SymbolRow (Symbol symbol, State state) {
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
        var s = this.symbol;

        this.title.label = s.name;

        this.price.label = @"%'.$(s.precision)F".printf (s.regular_market_price);

        this.currency.label = s.currency.up ();

        this.change.label =
            @"%'+.$(s.precision)F (%'+.2F%)".printf (
                s.regular_market_change,
                s.regular_market_change_percent
            );

        var change_style = this.change.get_style_context ();
        change_style.remove_class ("profit");
        change_style.remove_class ("loss");
        if (s.regular_market_change >= 0) {
            change_style.add_class ("profit");
        } else {
            change_style.add_class ("loss");
        }

        var market_style = this.market.get_style_context ();
        market_style.remove_class ("open");
        market_style.remove_class ("dim-label");
        if (s.is_marked_closed) {
            this.market.label = _("Market Closed");
            market_style.add_class ("dim-label");
        } else {
            this.market.label = _("Market Open");
            market_style.add_class ("open");
        }

        if (s.regular_market_time != null) {
            this.time.label = s.regular_market_time
                               .to_local ()
                               .format ("%b %e, %X");
        }
    }

    private void on_view_mode_update () {
        this.checkbox.visible =
            this.state.view_mode == State.ViewMode.SELECTION;
    }

    private void on_selection_mode_update () {
        switch (this.state.selection_mode) {
            case State.SelectionMode.ALL:
                this.symbol.selected = true;
                this.checkbox.active = true;
                break;
            case State.SelectionMode.NONE:
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

    public void on_row_clicked () {
        if (this.state.view_mode == State.ViewMode.SELECTION) {
            this.checkbox.active = !this.checkbox.active;
        } else {
            this.state.link = this.symbol.link;
        }
    }
}
