public class Markets.State : Object {
    public enum ViewMode {
        PRESENTATION,
        SELECTION
    }

    public enum NetworkStatus {
        IDLE,
        IN_PROGRESS,
    }

    public ViewMode view_mode {
        get; set; default = ViewMode.PRESENTATION;
    }

    public bool has_selected {
        get; set; default = false;
    }

    public NetworkStatus network_status {
        get; set; default = NetworkStatus.IDLE;
    }

    public Gee.ArrayList<Symbol> search_results {
        get; set; default = new Gee.ArrayList<Symbol> ();
    }

    public string search_query {
        get; set; default = "";
    }

    public int pull_interval {
        get; set;
    }

    public bool dark_theme {
        get; set;
    }

    public int search_selection {
        get; set; default = -1;
    }

    public int window_width {
        get; set;
    }

    public int window_height {
        get; set;
    }

    public string link {
        get; set;
    }

    public Gee.ArrayList<Symbol> symbols {
        get; set; default = new Gee.ArrayList<Symbol> ();
    }

    public void add_symbol (Symbol new_symbol) {
        var found = this.find_symbol (new_symbol.id);
        if (found != null) {
            warning ("The symbol already exists. Skipping the add operation.");
            return;
        }

        var copy = new Gee.ArrayList<Symbol> ();

        copy.add_all (this.symbols);
        copy.add (new_symbol);

        // create new array in order to enforce a notification
        this.symbols = copy;
    }

    public void move_symbol (Symbol src, Symbol dst) {
        var copy = new Gee.ArrayList<Symbol> ();

        copy.add_all (this.symbols);

        var src_idx = copy.index_of (src);
        var dst_idx = copy.index_of (dst);

        copy.remove_at (src_idx);
        copy.insert (dst_idx, src);

        // create new array in order to enforce a notification
        this.symbols = copy;
    }

    public void remove_symbols (Gee.ArrayList<string> ids) {
        var filtered = new Gee.ArrayList<Symbol> ();

        foreach (Symbol symbol in this.symbols) {
            var found = false;

            foreach (string id in ids) {
                if (symbol.id == id) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                filtered.add (symbol);
            }
        }

        // create new array in order to enforce a notification
        this.symbols = filtered;

        this.update_has_selected ();
    }

    public string[] get_symbol_ids () {
        var ids = new Gee.HashSet<string> ();

        foreach (Symbol symbol in this.symbols) {
            ids.add (symbol.id);
        }

        return ids.to_array ();
    }

    public Symbol ? find_symbol (string id) {
        foreach (Symbol symbol in this.symbols) {
            if (symbol.id == id) {
                return symbol;
            }
        }

        return null;
    }

    public void select_all() {
        foreach (Symbol symbol in this.symbols) {
            symbol.selected = true;
        }
        this.update_has_selected ();
    }

    public void select_none() {
        foreach (Symbol symbol in this.symbols) {
            symbol.selected = false;
        }
        this.update_has_selected ();
    }


    public void select(Symbol symbol, bool active) {
        symbol.selected = active;
        this.update_has_selected ();
    }

    private void update_has_selected () {
        foreach (Symbol symbol in this.symbols) {
            if (symbol.selected) {
                this.has_selected = true;
                return;
            }
        }
        this.has_selected = false;
    }
}
