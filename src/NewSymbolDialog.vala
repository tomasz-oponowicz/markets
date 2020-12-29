[GtkTemplate (ui = "/com/bitstower/Markets/NewSymbolDialog.ui")]
public class Markets.NewSymbolDialog : Gtk.Dialog {

    [GtkChild]
    private Gtk.TreeView results_view;

    [GtkChild]
    private Gtk.Button save_button;

    [GtkChild]
    private Gtk.SearchEntry search_entry;

    private Markets.State state;
    private Gtk.ListStore store;

    public NewSymbolDialog (Gtk.Window parent, State state) {
        Object (transient_for: parent, use_header_bar: 1);

        this.state = state;
        this.store = new Gtk.ListStore (1, typeof (string));
        this.results_view.model = this.store;

        // Reset the search state.
        //
        // There might be leftovers from a previous search.
        this.state.search_query = "";
        this.state.search_results = new Gee.ArrayList<Symbol> ();

        this.state.notify["search-results"].connect (this.on_search_results_updated);
    }

    private void on_search_results_updated () {
        this.store.clear ();

        Gtk.TreeIter iter;
        foreach (Symbol symbol in this.state.search_results) {
            this.store.append (out iter);
            var label = symbol.id + " · " +
                        symbol.name + " · " +
                        symbol.instrument_type + " · " +
                        symbol.exchange_name;
            this.store.set (iter, 0, label);
        }
    }

    [GtkCallback]
    private void on_search_changed () {
        this.save_button.sensitive = false;
        this.state.search_query = this.search_entry.text;
    }

    [GtkCallback]
    private void on_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column) {
        this.state.search_selection = path.get_indices ()[0];

        var selection = this.results_view.get_selection ();
        this.save_button.sensitive = selection.count_selected_rows () > 0;
    }

    [GtkCallback]
    private void on_save_clicked () {
        var new_symbol = this.state.search_results[this.state.search_selection];
        this.state.add_symbol (new_symbol);
    }
}
