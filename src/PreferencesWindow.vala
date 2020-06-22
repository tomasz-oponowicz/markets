[GtkTemplate (ui = "/com/bitstower/Markets/PreferencesWindow.ui")]
public class Markets.PreferencesWindow : Hdy.PreferencesWindow {

    [GtkChild]
    Gtk.Entry apiKeyEntry;

    public PreferencesWindow (Gtk.Application app, Gtk.Window parent) {
	    Object (application: app);
	    set_transient_for (parent);

        var apiKey = Application.settings.get_string("api-key");
        apiKeyEntry.text = apiKey;

	    apiKeyEntry.changed.connect (onApiKeyChanged);
    }

    public void onApiKeyChanged () {
        var apiKey = apiKeyEntry.text;

        if (apiKey.length < 10) {
            apiKeyEntry.get_style_context ().add_class ("error");
            return;
        }

        apiKeyEntry.get_style_context ().remove_class ("error");
        Application.settings.set_string("api-key", apiKey);
    }
}
