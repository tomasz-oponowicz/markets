[GtkTemplate (ui = "/com/bitstower/Markets/new_symbol.ui")]
public class Markets.NewSymbolDialog : Hdy.Dialog {

    [GtkChild]
    Gtk.TreeView treeView;

    [GtkChild]
    Gtk.Button addButton;

    [GtkChild]
    Gtk.SearchEntry searchEntry;

    private Markets.State state;
    private Gtk.ListStore store;

    public NewSymbolDialog (Gtk.Window parent, Markets.State state) {
        Object (transient_for: parent, use_header_bar: 1);

        this.state = state;
        this.store = new Gtk.ListStore(1, typeof(string));

        Gtk.TreeIter iter;

        var symbols = this.state.symbols;
        for (var i = 0; i < symbols.size; i++) {
          var symbol = symbols[i];
          if (symbol.description.length > 0) {
            this.store.append (out iter);
            this.store.set (iter, 0, @"$(symbol.name) · $(symbol.description)");
          }
        }

        this.treeView.set_search_entry(this.searchEntry);
        this.treeView.set_search_equal_func(this.compare);

        // Set model when the ListStore has all data.
        // Otherwise it may effect performance.
        this.treeView.model = this.store;

    }

    [GtkCallback]
    private void onSearchChanged () {
        this.onRowActivated ();
    }


    [GtkCallback]
    private void onRowActivated () {
        var selection = this.treeView.get_selection ();
        this.addButton.sensitive = selection.count_selected_rows () > 0;
    }

    private bool compare (Gtk.TreeModel model, int column, string key, Gtk.TreeIter iter) {
      string name;

      model.get (iter, column, out name);

      var name_lowercase = name.down();
      var key_lowercase = key.down();
      var found = name_lowercase.contains(key_lowercase);

      return !found;
    }
}
