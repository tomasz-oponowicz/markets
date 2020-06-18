[GtkTemplate (ui = "/com/bitstower/Markets/HeaderBar.ui")]
public class Markets.HeaderBar : Hdy.HeaderBar {

	[GtkChild]
	Gtk.MenuButton menuBtn;

	[GtkChild]
	Gtk.Button addBtn;

	[GtkChild]
	Gtk.Button selectBtn;

	[GtkChild]
	Gtk.Button deleteBtn;

	[GtkChild]
	Gtk.Button cancelBtn;

	[GtkChild]
	Gtk.Spinner spinner;

    public HeaderBar (Gtk.ApplicationWindow parent) {
        var builder1 = new Gtk.Builder.from_resource("/com/bitstower/Markets/menu.ui");
        var main_menu = (GLib.MenuModel) builder1.get_object("main-menu");
        menuBtn.set_menu_model(main_menu);

        addBtn.clicked.connect (() => {
            var dialog = new Markets.NewSymbolDialog (parent);
            dialog.run ();
            dialog.destroy ();
        });


        selectBtn.clicked.connect (() => {
            this.set_show_close_button(false);
            addBtn.visible = false;
            selectBtn.visible = false;
            menuBtn.visible = false;
            spinner.visible = false;

            cancelBtn.visible = true;
            deleteBtn.visible = true;

            this.get_style_context().add_class("selection-mode");
        });


        cancelBtn.clicked.connect (() => {
            this.set_show_close_button(true);
            addBtn.visible = true;
            selectBtn.visible = true;
            menuBtn.visible = true;
            spinner.visible = true;

            cancelBtn.visible = false;
            deleteBtn.visible = false;

            this.get_style_context().remove_class("selection-mode");
        });
    }
}
