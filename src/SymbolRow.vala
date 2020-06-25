[GtkTemplate (ui = "/com/bitstower/Markets/SymbolRow.ui")]
public class Markets.SymbolRow : Gtk.ListBoxRow {

    [GtkChild]
    Gtk.Label title;

    [GtkChild]
    Gtk.Label change;

    [GtkChild]
    Gtk.Label price;

    [GtkChild]
    Gtk.Label currency;

    [GtkChild]
    Gtk.Label details;

    [GtkChild]
    Gtk.CheckButton checkbox;

    private Markets.State state;

    public SymbolRow (string title, string price, string currency, string change, Markets.State state) {
        Object ();

        this.title.label = title;
        this.change.label = change;
        this.price.label = price;
        this.currency.label = currency;
        this.details.label = "MARKET OPEN";

        this.state = state;

        this.checkbox.toggled.connect (this.onCheckboxToggled);
	    this.state.notify["viewMode"].connect (this.onViewModeUpdate);
	    this.state.notify["selectionMode"].connect (this.onSelectionModeUpdate);

        this.onViewModeUpdate ();
	    this.onSelectionModeUpdate ();
	}

	private void onViewModeUpdate () {
        this.checkbox.visible =
            this.state.viewMode == Markets.ViewMode.SELECTION;
	}

	private void onSelectionModeUpdate () {
	    switch (this.state.selectionMode) {
	        case Markets.SelectionMode.ALL:
                this.checkbox.active = true;
                break;
	        case Markets.SelectionMode.NONE:
                this.checkbox.active = false;
                break;
	    }
	}

	private void onCheckboxToggled () {
	    if (this.checkbox.active) {
	        this.state.totalSelected++;
	    } else {
	        this.state.totalSelected--;
	    }
	}
}
