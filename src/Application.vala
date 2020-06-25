public class Markets.Application : Gtk.Application {
    public static GLib.Settings settings;

    private Gtk.Window window;

	private Markets.State state;

    public Application () {
        Object (
           application_id : "com.bitstower.Markets",
           flags: ApplicationFlags.FLAGS_NONE
        );

        this.state = new Markets.State ();
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

        var selectionAll = new SimpleAction ("selection.all", null);
        selectionAll.activate.connect (onSelectionAll);
		add_action (selectionAll);

        var selectionNone = new SimpleAction ("selection.none", null);
        selectionNone.activate.connect (onSelectionNone);
		add_action (selectionNone);

		window = new Markets.MainWindow (this, this.state);
		window.present ();
    }

    private void onPreferences () {
        var preferences = new Markets.PreferencesWindow (this, window);
        preferences.present ();
    }

    private void onAbout () {
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

    private void onSelectionAll () {

        // Enforce update by changing to opposite value first
        this.state.selectionMode = Markets.SelectionMode.NONE;
        this.state.selectionMode = Markets.SelectionMode.ALL;
    }

    private void onSelectionNone () {

        // Enforce update by changing to opposite value first
        this.state.selectionMode = Markets.SelectionMode.ALL;
        this.state.selectionMode = Markets.SelectionMode.NONE;
    }

    public static int main (string [] args) {
        var app = new Application ();

        // Settings has to be created after Application.
        // Otherwise application freezes on start.
        Application.settings = new GLib.Settings ("com.bitstower.Markets");

        return app.run (args);
    }
}
