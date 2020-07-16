using Gee;

[GtkTemplate (ui = "/com/bitstower/Markets/new_symbol.ui")]
public class Markets.NewSymbolDialog : Hdy.Dialog {

    [GtkChild]
    Gtk.TreeView treeView;

    [GtkChild]
    Gtk.Button addButton;

    [GtkChild]
    Gtk.SearchEntry searchEntry;

    private Markets.Service service;
    private Markets.State state;
    private Gtk.ListStore store;

    public NewSymbolDialog (Gtk.Window parent, Markets.State state, Markets.Service service) {
        Object (transient_for: parent, use_header_bar: 1);

        this.state = state;
        this.service = service;
        this.store = new Gtk.ListStore(1, typeof(string));

        this.treeView.model = this.store;

        this.state.notify["search-results"].connect (this.onSearchResultsUpdated);
    }

    private void onSearchResultsUpdated () {
      this.store.clear ();

      Gtk.TreeIter iter;
      var search_results = this.state.search_results;
      for (var i = 0; i < search_results.size; i++) {
        var symbol = search_results[i];
        this.store.append (out iter);
        this.store.set (iter, 0, @"$(symbol.id) · $(symbol.name) · $(symbol.instrument_type) · $(symbol.exchange_name)");
      }
    }

    [GtkCallback]
    private void onSearchChanged () {
        this.addButton.sensitive = false;

        var query = this.searchEntry.text;
        this.service.search.begin(query, (obj, res) => {
          this.service.search.end(res);
        });
    }

    [GtkCallback]
    private void onRowActivated (Gtk.TreePath path, Gtk.TreeViewColumn column) {
        this.state.search_selection = path.get_indices ()[0];

        var selection = this.treeView.get_selection ();
        this.addButton.sensitive = selection.count_selected_rows () > 0;
    }

    [GtkCallback]
    private void onAddClicked () {
        var new_symbol = this.state.search_results[this.state.search_selection];

        var copy = new ArrayList<Symbol> ();
        copy.add_all (this.state.favourite_symbols);
        copy.add (new_symbol);

        this.state.favourite_symbols = copy;
    }
}
