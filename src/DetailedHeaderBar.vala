[GtkTemplate (ui = "/com/bitstower/Markets/DetailedHeaderBar.ui")]
public class Markets.DetailedHeaderBar : Hdy.HeaderBar {
    private State state;

    public DetailedHeaderBar (MainWindow window, State state) {
        this.state = state;
    }

    [GtkCallback]
    private void on_back_clicked () {
        this.state.back_clicked ();
    }
}
