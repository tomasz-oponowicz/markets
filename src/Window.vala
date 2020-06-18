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

		public Window (Gtk.Application app) {
		    this.application = app;

		    this.set_titlebar (new Markets.HeaderBar (this));

            var view = new Markets.SymbolsView ();
            stack.add_named(view, "symbols");
		    stack.set_visible_child_name("symbols");
		}
	}
}
