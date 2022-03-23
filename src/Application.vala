public class Markets.Application : Gtk.Application {
    private Gtk.Window window;

    private State state;
    private Service service;

    private const ActionEntry[] app_entries =
    {
        { "quit", on_quit, null, null, null },
    };

    public Application () {
        Object (
            application_id: Constants.APP_ID,
            flags : ApplicationFlags.FLAGS_NONE
        );

        this.service = new Service ();
        this.state = this.service.state;
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
        preferences.activate.connect (on_preferences);
        add_action (preferences);

        var about = new SimpleAction ("about", null);
        about.activate.connect (on_about);
        add_action (about);

        var selection_all = new SimpleAction ("selection.all", null);
        selection_all.activate.connect (on_selection_all);
        add_action (selection_all);

        var selection_none = new SimpleAction ("selection.none", null);
        selection_none.activate.connect (on_selection_none);
        add_action (selection_none);

        this.add_action_entries (app_entries, this);

        this.set_accels_for_action ("app.quit", {"<control>Q"});

        this.service.init ();

        this.window = new MainWindow (this, this.state);
        this.window.present ();
    }

    private void on_preferences () {
        var preferences = new PreferencesWindow (this, window, this.state);

        preferences.present ();
    }

    private void on_about () {
        var dialog = new Gtk.AboutDialog ();

        dialog.set_destroy_with_parent (true);
        dialog.set_transient_for (window);
        dialog.set_modal (true);
        dialog.logo_icon_name = Constants.APP_ID;
        dialog.program_name = _("Markets");
        dialog.comments = _("Keep track of your investments");
        dialog.authors = { "Tomasz Oponowicz" };
        // TRANSLATORS: 'Name <email@domain.com>' or 'Name https://website.example'
        dialog.translator_credits = _("translator-credits");
        dialog.artists = {"Tobias Bernard"};
        dialog.license_type = Gtk.License.GPL_3_0;
        dialog.website = "https://bitstower.com";
        dialog.website_label = _("Official webpage");

        dialog.run ();
        dialog.destroy ();
    }

    private void on_selection_all () {
        this.state.select_all ();
    }

    private void on_selection_none () {
        this.state.select_none ();
    }

    private void on_quit () {
        this.window.close ();
    }

    public static int main (string[] args) {

        // Init internationalization support
        Intl.setlocale (LocaleCategory.ALL, "");
        string langpack_dir = Path.build_filename (Constants.APP_INSTALL_PREFIX, "share", "locale");
        Intl.bindtextdomain (Constants.APP_ID, langpack_dir);
        Intl.bind_textdomain_codeset (Constants.APP_ID, "UTF-8");
        Intl.textdomain (Constants.APP_ID);

        var app = new Application ();
        app.startup.connect (() => {
            Hdy.init ();

            Hdy.StyleManager.get_default ().color_scheme = PREFER_LIGHT;
        });
        return app.run (args);
    }
}
