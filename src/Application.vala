using Gee;

namespace Markets {

    public class Application : Gtk.Application {
        public static GLib.Settings settings;

        private Gtk.Window window;

        private Markets.State state;
        private Markets.Service service;

        public Application () {
            Object (
                application_id: "com.bitstower.Markets",
                flags : ApplicationFlags.FLAGS_NONE
            );

            this.state = new Markets.State ();
            this.service = new Markets.Service (this.state);
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

            this.service.load_favourite_symbols ();
            this.service.on_tick ();

            window = new Markets.MainWindow (this, this.state, this.service);
            window.present ();
        }

        private void on_preferences () {
            var preferences = new Markets.PreferencesWindow (this, window, this.state);
            preferences.present ();
        }

        private void on_about () {
            var dialog = new Gtk.AboutDialog ();

            dialog.set_destroy_with_parent (true);
            dialog.set_transient_for (window);
            dialog.set_modal (true);
            dialog.logo_icon_name = "com.bitstower.Markets";
            dialog.program_name = "Markets";
            dialog.comments = "A market tracker for Linux Smartphones and Tablets.";
            dialog.authors = { "Tomasz Oponowicz" };
            dialog.license_type = Gtk.License.GPL_3_0;
            dialog.website = "https://bitstower.com";
            dialog.website_label = "Official webpage";

            dialog.run ();
            dialog.destroy ();
        }

        private void on_selection_all () {

            // Enforce update by changing to opposite value first
            this.state.selectionMode = Markets.SelectionMode.NONE;
            this.state.selectionMode = Markets.SelectionMode.ALL;
        }

        private void on_selection_none () {

            // Enforce update by changing to opposite value first
            this.state.selectionMode = Markets.SelectionMode.ALL;
            this.state.selectionMode = Markets.SelectionMode.NONE;
        }

        public static int main (string[] args) {
            var app = new Application ();

            // Settings has to be created after Application.
            // Otherwise application freezes on start.
            Application.settings = new GLib.Settings ("com.bitstower.Markets");

            return app.run (args);
        }
    }
}
