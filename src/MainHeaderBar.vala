[GtkTemplate (ui = "/biz/zaxo/Markets/MainHeaderBar.ui")]
public class Markets.MainHeaderBar : Hdy.HeaderBar {
    private Markets.MainWindow window;
    private Markets.State state;

    [GtkChild]
    private Gtk.MenuButton menu_button;

    [GtkChild]
    private Gtk.Spinner spinner;

    public MainHeaderBar (MainWindow window, State state) {
        this.window = window;
        this.state = state;

        this.state.notify["network-status"].connect (this.on_network_status_updated);

        this.menu_button.add_accelerator (
            "clicked",
            window.accel_group,
            Gdk.Key.F10,
            0,
            Gtk.AccelFlags.VISIBLE
        );
    }

    [GtkCallback]
    private void on_add_clicked () {
        var dialog = new NewSymbolDialog (this.window, this.state);
        dialog.run ();
        dialog.destroy ();
    }

    [GtkCallback]
    private void on_select_clicked () {
        this.state.view_mode = State.ViewMode.SELECTION;
    }

    private void on_network_status_updated () {
        this.spinner.visible =
            this.state.network_status == State.NetworkStatus.IN_PROGRESS;
    }
}
