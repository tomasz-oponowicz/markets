/* window.vala
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

namespace Markets {
	[GtkTemplate (ui = "/com/bitstower/Markets/window.ui")]
	public class Window : Gtk.ApplicationWindow {
		[GtkChild]
		Gtk.Stack stack;

		[GtkChild]
		Gtk.MenuButton menuBtn;

		[GtkChild]
		Gtk.Button addBtn;

		public Window (Gtk.Application app) {
			Object (application: app);
		}

		construct {
            var builder1 = new Gtk.Builder.from_resource("/com/bitstower/Markets/menu.ui");
            var main_menu = (GLib.MenuModel) builder1.get_object("main-menu");
            menuBtn.set_menu_model(main_menu);

            var view = new Markets.SymbolsView ();
            stack.add_named(view, "symbols");
		    stack.set_visible_child_name("symbols");

		    addBtn.clicked.connect (() => {
                var dialog = new Markets.NewSymbolDialog (this);
                dialog.run ();
                dialog.destroy ();
		    });
		}
	}
}
