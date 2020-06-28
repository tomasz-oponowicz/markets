[GtkTemplate (ui = "/com/bitstower/Markets/MainHeaderBar.ui")]
public class Markets.MainHeaderBar : Hdy.HeaderBar {
    private Gtk.ApplicationWindow parentWindow;
    private Markets.State state;

    [GtkChild]
    private Gtk.Spinner spinner;

    public MainHeaderBar (Gtk.ApplicationWindow parentWindow, Markets.State state) {
        Object ();

        this.parentWindow = parentWindow;
        this.state = state;

        this.state.notify["networkStatus"].connect (onNetworkStatusUpdated);
    }

    [GtkCallback]
    private void onAddClicked () {
        var dialog = new Markets.NewSymbolDialog (this.parentWindow, this.state);
        dialog.run ();
        dialog.destroy ();
    }

    [GtkCallback]
    private void onSelectClicked () {
        this.state.viewMode = Markets.ViewMode.SELECTION;
    }

    private void onNetworkStatusUpdated () {
        this.spinner.visible =
            this.state.networkStatus == Markets.NetworkStatus.IN_PROGRESS;
    }
}
