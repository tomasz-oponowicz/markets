[GtkTemplate (ui = "/com/bitstower/Markets/MainHeaderBar.ui")]
public class Markets.MainHeaderBar : Hdy.HeaderBar {
    private Gtk.ApplicationWindow parentWindow;
    private Markets.State state;

    public MainHeaderBar (Gtk.ApplicationWindow parentWindow, Markets.State state) {
        Object ();

        this.parentWindow = parentWindow;
        this.state = state;
    }

    [GtkCallback]
    private void onAddClicked () {
        var dialog = new Markets.NewSymbolDialog (this.parentWindow);
        dialog.run ();
        dialog.destroy ();
    }

    [GtkCallback]
    private void onSelectClicked () {
        this.state.viewMode = Markets.ViewMode.SELECTION;
    }
}
