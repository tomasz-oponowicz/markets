[GtkTemplate (ui = "/com/bitstower/Markets/MainHeaderBar.ui")]
public class Markets.MainHeaderBar : Hdy.HeaderBar {
    private Gtk.ApplicationWindow parent_window;
    private Markets.State state;

    [GtkChild]
    private Gtk.Spinner spinner;

    public MainHeaderBar (Gtk.ApplicationWindow parent_window, Markets.State state) {
        Object ();

        this.parent_window = parent_window;
        this.state = state;

        this.state.notify["network-status"].connect (this.on_network_status_updated);
    }

    [GtkCallback]
    private void on_add_clicked () {
        var dialog = new Markets.NewSymbolDialog (this.parent_window, this.state);
        dialog.run ();
        dialog.destroy ();
    }

    [GtkCallback]
    private void on_select_clicked () {
        this.state.view_mode = Markets.ViewMode.SELECTION;
    }

    private void on_network_status_updated () {
        this.spinner.visible =
            this.state.network_status == Markets.NetworkStatus.IN_PROGRESS;
    }
}
