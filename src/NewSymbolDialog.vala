using Gee;

[GtkTemplate (ui = "/com/bitstower/Markets/new_symbol.ui")]
public class Markets.NewSymbolDialog : Hdy.Dialog {

    [GtkChild]
    private Gtk.TreeView results_view;

    [GtkChild]
    private Gtk.Button save_button;

    [GtkChild]
    private Gtk.SearchEntry search_entry;

    private Markets.Service service;
    private Markets.State state;
    private Gtk.ListStore store;

    public NewSymbolDialog (Gtk.Window parent, Markets.State state, Markets.Service service) {
        Object (transient_for: parent, use_header_bar: 1);

        this.state = state;
        this.service = service;
        this.store = new Gtk.ListStore (1, typeof (string));

        this.results_view.model = this.store;

        this.state.notify["search-results"].connect (this.on_search_results_updated);
    }

    private void on_search_results_updated () {
        this.store.clear ();

        Gtk.TreeIter iter;
        var search_results = this.state.search_results;
        for (var i = 0; i < search_results.size; i++) {
            var symbol = search_results[i];
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

        var query = this.search_entry.text;
        this.service.search.begin (query, (obj, res) => {
            this.service.search.end (res);
        });
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

        var copy = new ArrayList<Symbol> ();
        copy.add_all (this.state.favourite_symbols);
        copy.add (new_symbol);

        this.state.favourite_symbols = copy;
    }
}
