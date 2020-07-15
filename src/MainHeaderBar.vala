[GtkTemplate (ui = "/com/bitstower/Markets/MainHeaderBar.ui")]
public class Markets.MainHeaderBar : Hdy.HeaderBar {
    private Gtk.ApplicationWindow parentWindow;
    private Markets.State state;
    private Markets.Service service;

    [GtkChild]
    private Gtk.Spinner spinner;

    public MainHeaderBar (Gtk.ApplicationWindow parentWindow, Markets.State state, Markets.Service service) {
        Object ();

        this.parentWindow = parentWindow;
        this.state = state;
        this.service = service;

        this.state.notify["networkStatus"].connect (this.onNetworkStatusUpdated);
    }

    [GtkCallback]
    private void onAddClicked () {
        var dialog = new Markets.NewSymbolDialog (this.parentWindow, this.state, this.service);
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
