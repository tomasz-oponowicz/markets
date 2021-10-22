[GtkTemplate (ui = "/com/bitstower/Markets/SymbolRow.ui")]
public class Markets.SymbolRow : Gtk.ListBoxRow {

    [GtkChild]
    private Gtk.Label title1;

    [GtkChild]
    private Gtk.Label title2;

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

    [GtkChild]
    private Gtk.EventBox drag_handle;

    [GtkChild]
    private Gtk.Image drag_icon;

    [GtkChild]
    private Gtk.Box extra_info;

    [GtkChild]
    private Gtk.Box price_info;

    private State state;

    private Symbol symbol;

    private const Gtk.TargetEntry[] TARGET_ENTRIES = {
        {"SYMBOLROW", Gtk.TargetFlags.SAME_APP, 0}
    };

    public SymbolRow (Symbol symbol, State state) {
        this.symbol = symbol;
        this.state = state;

        this.symbol.notify.connect (this.on_symbol_update);
        this.state.notify["view-mode"].connect (this.on_view_mode_update);

        this.on_symbol_update ();
        this.on_view_mode_update ();

        Gtk.drag_source_set (
            this.drag_handle, Gdk.ModifierType.BUTTON1_MASK, TARGET_ENTRIES, Gdk.DragAction.MOVE
        );

        Gtk.drag_dest_set (
            this, Gtk.DestDefaults.ALL, TARGET_ENTRIES, Gdk.DragAction.MOVE
        );
    }

    private void on_symbol_update () {
        var s = this.symbol;

        this.checkbox.active = s.selected;

        this.title1.label = s.name;
        this.title2.label = s.name;

        this.price.label = @"%'.$(s.precision)F".printf (s.regular_market_price);

        this.currency.label = s.currency.up ();
        this.currency.visible = s.currency != ""; // Hide currency for market indices

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
        var visible = this.state.view_mode == State.ViewMode.SELECTION;
        this.title1.visible = !visible;
        this.extra_info.visible = !visible;
        this.price_info.visible = !visible;
        this.title2.visible = visible;
        this.checkbox.visible = visible;
        this.drag_icon.visible = visible;
        this.activatable = !visible;
    }

    [GtkCallback]
    private void on_checkbox_toggled () {
        this.state.select(this.symbol, this.checkbox.active);
    }

    public void on_row_clicked () {
        if (this.state.view_mode == State.ViewMode.PRESENTATION) {
            this.state.link = this.symbol.link;
        }
    }

    [GtkCallback]
    private void on_drag_begin (Gtk.Widget widget, Gdk.DragContext context) {
        var row = ((SymbolRow) widget);
        row.get_style_context ().add_class ("drag-begin");
    }

    [GtkCallback]
    private void on_drag_end (Gtk.Widget widget, Gdk.DragContext context) {
        var row = ((SymbolRow) widget);
        row.get_style_context ().remove_class ("drag-begin");
    }

    [GtkCallback]
    private void on_drag_data_get (
        Gdk.DragContext ctx, Gtk.SelectionData selection_data,
        uint info, uint time_
    ) {
        uchar[] data = new uchar[(sizeof (Gtk.Widget))];
        ((Gtk.Widget[]) data)[0] = this.parent.parent;

        selection_data.set (
            Gdk.Atom.intern_static_string ("SYMBOLROW"), 32, data
        );
	}

    [GtkCallback]
    private void on_drag_received (
        Gdk.DragContext context, int x, int y,
        Gtk.SelectionData selection_data, uint target_type
    ) {
        var row = ((Gtk.Widget[]) selection_data.get_data ())[0];

        Symbol src = ((SymbolRow) row).symbol;
        Symbol dst = this.symbol;

        this.state.move_symbol (src, dst);
    }
}
