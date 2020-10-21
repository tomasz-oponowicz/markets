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

    [GtkChild]
    private Gtk.EventBox drag_handle;

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
        this.state.notify["selection-mode"].connect (this.on_selection_mode_update);

        this.on_symbol_update ();
        this.on_view_mode_update ();
        this.on_selection_mode_update ();

        Gtk.drag_source_set (
            this, Gdk.ModifierType.BUTTON1_MASK, TARGET_ENTRIES, Gdk.DragAction.MOVE
        );

        Gtk.drag_dest_set (
             this, Gtk.DestDefaults.ALL, TARGET_ENTRIES, Gdk.DragAction.MOVE
        );

        this.drag_begin.connect (this.on_drag_begin);
        this.drag_data_get.connect (this.on_drag_data_get);
        this.drag_data_received.connect (this.on_drag_received);
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
        var visible = this.state.view_mode == State.ViewMode.SELECTION;
        this.checkbox.visible = visible;
        this.drag_handle.visible = visible;
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

    private void on_drag_begin (Gtk.Widget widget, Gdk.DragContext context) {
        var row = ((SymbolRow) widget);

        Gtk.Allocation alloc;
        row.get_allocation (out alloc);

        var surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, alloc.width, alloc.height);
        var cr = new Cairo.Context (surface);
        cr.set_source_rgba (0, 0, 0, 0);
        cr.set_line_width (1);

        cr.move_to (0, 0);
        cr.line_to (alloc.width, 0);
        cr.line_to (alloc.width, alloc.height);
        cr.line_to (0, alloc.height);
        cr.line_to (0, 0);
        cr.stroke ();

        cr.set_source_rgba (255, 255, 255, 0);
        cr.rectangle (0, 0, alloc.width, alloc.height);
        cr.fill ();

        row.get_style_context ().add_class ("drag-begin");
        row.draw (cr);
        row.get_style_context ().remove_class ("drag-begin");

        Gtk.drag_set_icon_surface (context, surface);
    }

    private void on_drag_data_get (
        Gdk.DragContext ctx, Gtk.SelectionData selection_data,
        uint info, uint time_
    ) {
        uchar[] data = new uchar[(sizeof (Gtk.Widget))];
        ((Gtk.Widget[]) data)[0] = this;

        selection_data.set (
            Gdk.Atom.intern_static_string ("SYMBOLROW"), 32, data
        );
	}

    private void on_drag_received (
        Gdk.DragContext context, int x, int y,
        Gtk.SelectionData selection_data, uint target_type
    ) {
        var row = ((Gtk.Widget[]) selection_data.get_data ())[0];

        Symbol src = ((SymbolRow) row).symbol;
        Symbol dst = this.symbol;

        this.state.swap_symbols (src, dst);
    }
}
