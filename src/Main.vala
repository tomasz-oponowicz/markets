/* main.vala
 *
 * Copyright 2020 Tomasz Oponowicz
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

int main (string[] args) {
    Gtk.Window window = null;
	var app = new Gtk.Application ("com.bitstower.Markets", ApplicationFlags.FLAGS_NONE);
	app.activate.connect (() => {
		window = app.active_window;
		if (window == null) {
			window = new Markets.Window (app);
		}
		window.present ();
	});
	app.startup.connect (() => {
        var settings = new SimpleAction ("settings", null);
        settings.activate.connect (() => {
            var preferences = new Markets.PreferencesWindow (app);
		    preferences.present ();
        });
		app.add_action (settings);

        var about = new SimpleAction ("about", null);
        about.activate.connect (() => {
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
        });
		app.add_action (about);
	});

	return app.run (args);
}
