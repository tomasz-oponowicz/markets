public class Markets.Application : Gtk.Application {
    public static GLib.Settings settings;

    private Gtk.Window window;

    public Application () {
        Object (
           application_id : "com.bitstower.Markets",
           flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate () {
        if (active_window != null) {
            return;
        }

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/bitstower/Markets/Application.css");
        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        var preferences = new SimpleAction ("preferences", null);
        preferences.activate.connect (onPreferences);
		add_action (preferences);

        var about = new SimpleAction ("about", null);
        about.activate.connect (onAbout);
		add_action (about);

		window = new Markets.MainWindow (this);
		window.present ();
    }

    public void onPreferences () {
        var preferences = new Markets.PreferencesWindow (this, window);
        preferences.present ();
    }

    public void onAbout () {
        var dialog = new Gtk.AboutDialog ();

        dialog.set_destroy_with_parent (true);
        dialog.set_transient_for (window);
        dialog.set_modal (true);
        dialog.logo_icon_name = "com.bitstower.Markets";
        dialog.program_name = "Markets";
        dialog.comments = "A market tracker for Linux Smartphones and Tablets.";
        dialog.authors = {"Tomasz Oponowicz"};
        dialog.license_type = Gtk.License.GPL_3_0;
        dialog.website = "https://bitstower.com";
        dialog.website_label = "Official webpage";

        dialog.run();
        dialog.destroy();
    }

    public static int main (string [] args) {
        var app = new Application ();

        // Settings has to be created after Application.
        // Otherwise application freezes on start.
        Application.settings = new GLib.Settings ("com.bitstower.Markets");

        return app.run (args);
    }
}
