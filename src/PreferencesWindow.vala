[GtkTemplate (ui = "/com/bitstower/Markets/preferences.ui")]
public class Markets.PreferencesWindow : Hdy.PreferencesWindow {
    public PreferencesWindow (Gtk.Application app, Gtk.Window parent) {
	    Object (application: app);
	    set_transient_for (parent);
    }
}
