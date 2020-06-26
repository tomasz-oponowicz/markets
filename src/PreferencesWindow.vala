[GtkTemplate (ui = "/com/bitstower/Markets/PreferencesWindow.ui")]
public class Markets.PreferencesWindow : Hdy.PreferencesWindow {

    [GtkChild]
    Gtk.Entry apiKeyEntry;

    public PreferencesWindow (Gtk.Application app, Gtk.Window parent) {
	    Object (application: app);
	    set_transient_for (parent);

        var apiKey = Application.settings.get_string("api-key");
        apiKeyEntry.text = apiKey;
    }

    [GtkCallback]
    private void onApiKeyChanged () {
        var apiKey = apiKeyEntry.text;

        apiKeyEntry.get_style_context ().remove_class ("valid");
        apiKeyEntry.get_style_context ().remove_class ("not-valid");

        if (apiKey.length < 10) {
            apiKeyEntry.get_style_context ().add_class ("not-valid");
            apiKeyEntry.primary_icon_name = "dialog-warning-symbolic";
            apiKeyEntry.primary_icon_tooltip_text = "This is not a valid value";
            return;
        }

        apiKeyEntry.get_style_context ().add_class ("valid");
        apiKeyEntry.primary_icon_name = "emblem-ok-symbolic";
        apiKeyEntry.primary_icon_tooltip_text = "";
        Application.settings.set_string("api-key", apiKey);
    }
}
