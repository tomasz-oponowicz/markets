[GtkTemplate (ui = "/com/bitstower/Markets/new_symbol.ui")]
public class Markets.NewSymbolDialog : Hdy.Dialog {

    [GtkChild]
    Gtk.ListBox symbolList;

    [GtkChild]
    Gtk.Button addButton;

    [GtkChild]
    Gtk.SearchEntry searchEntry;

    private Markets.State state;

    public NewSymbolDialog (Gtk.Window parent, Markets.State state) {
        Object (transient_for: parent, use_header_bar: 1);

        this.state = state;

        this.state.symbols.foreach((symbol) => {
          var label = new Gtk.Label (symbol.name);
          label.halign = Gtk.Align.START;
          label.margin_start = 5;
          label.visible = true;
          symbolList.prepend (label);
          return true;
        });

        this.searchEntry.search_changed.connect (this.onSearchChanged);
        this.symbolList.row_selected.connect (this.onRowSelected);
        this.symbolList.set_filter_func (this.filter);
    }

    private void onRowSelected () {
        this.addButton.sensitive = true;
    }

    private void onSearchChanged () {
        this.symbolList.invalidate_filter ();
    }

    private bool filter (Gtk.ListBoxRow row) {
        var searchPhrase = this.searchEntry.text;

        if (searchPhrase == "") {
            return true;
        }

        var child = (Gtk.Label) row.get_child ();
        return child.label == searchPhrase;
    }
}
