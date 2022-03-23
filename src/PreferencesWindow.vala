[GtkTemplate (ui = "/com/bitstower/Markets/PreferencesWindow.ui")]
public class Markets.PreferencesWindow : Hdy.PreferencesWindow {

    [GtkChild]
    private Gtk.ComboBoxText pull_interval;

    private State state;

    public PreferencesWindow (Gtk.Application app, Gtk.Window parent, State state) {
        Object (transient_for: parent, application: app);

        this.state = state;
        this.pull_interval.active_id = this.state.pull_interval.to_string ();
    }

    [GtkCallback]
    private void on_pull_interval_changed () {
        this.state.pull_interval = int.parse (pull_interval.active_id);
    }
}
