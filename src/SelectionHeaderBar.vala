[GtkTemplate (ui = "/com/bitstower/Markets/SelectionHeaderBar.ui")]
public class Markets.SelectionHeaderBar : Hdy.HeaderBar {

	[GtkChild]
	Gtk.Button cancelBtn;

    private Markets.Model model;

    public SelectionHeaderBar (Markets.Model model) {
        Object ();

        this.model = model;

        this.set_show_close_button(false);
        this.cancelBtn.clicked.connect (this.onCancelClicked);
    }

    private void onCancelClicked () {
        this.model.selectionEnabled = false;
    }
}
