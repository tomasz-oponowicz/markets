[GtkTemplate (ui = "/biz/zaxo/Markets/PreferencesWindow.ui")]
public class Markets.PreferencesWindow : Hdy.PreferencesWindow {

    [GtkChild]
    private Gtk.ComboBoxText pull_interval;

    [GtkChild]
    private Gtk.Switch dark_theme;

    private State state;

    public PreferencesWindow (Gtk.Application app, Gtk.Window parent, State state) {
        Object (transient_for: parent, application: app);

        this.state = state;
        this.dark_theme.active = this.state.dark_theme;
        this.pull_interval.active_id = this.state.pull_interval.to_string ();
    }

    [GtkCallback]
    private bool on_dark_theme_changed (Gtk.Switch widget, bool enabled) {
        this.state.dark_theme = enabled;
        return false;
    }

    [GtkCallback]
    private void on_pull_interval_changed () {
        this.state.pull_interval = int.parse (pull_interval.active_id);
    }
}
