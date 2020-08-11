[GtkTemplate (ui = "/com/bitstower/Markets/SymbolsView.ui")]
public class Markets.SymbolsView : Gtk.ScrolledWindow {

    [GtkChild]
    private Gtk.ListBox symbols;

    private State state;

    internal Markets.SymbolRow? drag_row;

    public SymbolsView (State state) {
        this.state = state;

        //this.state.notify["symbols"].connect (this.on_symbols_update);
        this.on_symbols_update ();

        //this.symbols.set_selection_mode (Gtk.SelectionMode.BROWSE);
        this.symbols.set_activate_on_single_click (false);
        Gtk.drag_dest_set (
             this.symbols, Gtk.DestDefaults.ALL, entries, Gdk.DragAction.MOVE
        );
    }

    static Gtk.TargetEntry[] entries = {
        Gtk.TargetEntry () {
            target = "GTK_LIST_BOX_ROW",
            flags = Gtk.TargetFlags.SAME_APP,
            info = 0
        }
    };

    /*internal void add_cb () {
        Gtk.drag_source_set(this.drag_handle, Gdk.ModifierType.BUTTON1_MASK, entries, Gdk.DragAction.MOVE);
	    Gtk.drag_dest_set(this, Gtk.DestDefaults.ALL, entries, Gdk.DragAction.MOVE);
    }*/


    /*

    [GtkCallback]
    private void on_row_click (Gtk.ListBox box, Gtk.ListBoxRow row) {
        ((SymbolRow) row).on_row_clicked ();
    } */


    private void on_symbols_update () {
        var children = this.symbols.get_children ();
        foreach (Gtk.Widget widget in children) {
            this.symbols.remove (widget);
        }

        foreach (Symbol symbol in this.state.symbols) {
            symbols.add (new SymbolRow (symbol, state));
        }
    }
}
