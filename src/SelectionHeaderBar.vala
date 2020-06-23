[GtkTemplate (ui = "/com/bitstower/Markets/SelectionHeaderBar.ui")]
public class Markets.SelectionHeaderBar : Hdy.HeaderBar {

	[GtkChild]
	Gtk.Button cancelBtn;

    private Markets.State state;

    public SelectionHeaderBar (Markets.State state) {
        Object ();

        this.state = state;

        this.cancelBtn.clicked.connect (this.onCancelClicked);
    }

    private void onCancelClicked () {
        this.state.viewMode = Markets.ViewMode.PRESENTATION;
    }
}
