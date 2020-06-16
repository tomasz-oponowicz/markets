[GtkTemplate (ui = "/com/bitstower/Markets/new_symbol.ui")]
public class Markets.NewSymbolDialog : Hdy.Dialog {

    [GtkChild]
    Gtk.ListBox symbolList;

    [GtkChild]
    Gtk.Button addButton;

    public NewSymbolDialog (Gtk.Window parent) {
        Object (transient_for: parent, use_header_bar: 1);

        symbolList.row_selected.connect (() => {
            addButton.sensitive = true;
        });

        for (int i = 0; i < 20; i++) {
            var label = new Gtk.Label (i.to_string());
            label.halign = Gtk.Align.START;
            label.margin_start = 5;
            label.visible = true;
            symbolList.prepend (label);
        }
    }
}
