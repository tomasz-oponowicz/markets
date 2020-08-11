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

    static Gtk.TargetEntry[] entries = {
	    Gtk.TargetEntry () {
		    target = "GTK_LIST_BOX_ROW", flags = Gtk.TargetFlags.SAME_APP, info = 0
      }
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
            this.drag_handle, Gdk.ModifierType.BUTTON1_MASK, entries, Gdk.DragAction.MOVE
        );

        this.drag_handle.drag_begin.connect (handle_drag_begin);
        this.drag_handle.drag_data_get.connect (handle_drag_data_get);
    }

    public Markets.SymbolsView? get_drag_list_box () {
        Gtk.Widget? parent = this.get_parent ();
        if (parent != null) {
            return parent.get_parent () as Markets.SymbolsView;
        }
        return null;
    }

    private void handle_drag_begin (Gtk.Widget widget, Gdk.DragContext drag_context) {

        Markets.SymbolsView symbols_view;
        Gtk.Allocation alloc;
        Cairo.Surface surface;
        Cairo.Context cr;
        int x, y;

        get_allocation (out alloc);
        surface = new Cairo.ImageSurface (
            Cairo.Format.ARGB32, alloc.width, alloc.height
        );
        cr = new Cairo.Context (surface);

        symbols_view = get_drag_list_box ();
        if (symbols_view != null)
            symbols_view.drag_row = this;

        get_style_context ().add_class ("dragging");
        draw (cr);
        get_style_context ().remove_class ("dragging");

        this.drag_handle.translate_coordinates (this, 0, 0, out x, out y);
        surface.set_device_offset (-x, -y);
        Gtk.drag_set_icon_surface (drag_context, surface);
    }

    private void handle_drag_data_get (
        Gdk.DragContext ctx, Gtk.SelectionData selection_data,
        uint info, uint time_
    ) {
        uchar[] data = new uchar[(sizeof (Gtk.Widget))];
        ((Gtk.Widget[])data)[0] = this;

        selection_data.@set (
            Gdk.Atom.intern_static_string ("GTK_LIST_BOX_ROW"), 32, data
        );
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
            this.market.label = "Market Closed";
            market_style.add_class ("dim-label");
        } else {
            this.market.label = "Market Open";
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
