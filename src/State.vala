using Gee;

public enum Markets.ViewMode {
    PRESENTATION,
    SELECTION
}

public enum Markets.SelectionMode {
    NONE,
    ALL,
}

public enum Markets.NetworkStatus {
    IDLE,
    IN_PROGRESS,
}

public class Markets.State : Object {
    public Markets.ViewMode view_mode {
        get;
        set;
        default = Markets.ViewMode.PRESENTATION;
    }

    public Markets.SelectionMode selection_mode {
        get;
        set;
        default = Markets.SelectionMode.NONE;
    }

    public int total_selected {
        get;
        set;
        default = 0;
    }

    public Markets.NetworkStatus network_status {
        get;
        set;
        default = Markets.NetworkStatus.IDLE;
    }

    public ArrayList<Symbol> search_results {
        get;
        set;
        default = new ArrayList<Symbol> ();
    }

    public int pull_interval {
        get;
        set;
    }

    public bool dark_theme {
        get;
        set;
    }

    public int search_selection {
        get;
        set;
        default = -1;
    }

    public int window_width {
        get;
        set;
    }

    public int window_height {
        get;
        set;
    }

    public ArrayList<Symbol> favourite_symbols {
        get;
        set;
        default = new ArrayList<Symbol> ();
    }

    public string[] get_favourite_symbol_ids () {
        var ids = new HashSet<string> ();

        foreach (Symbol symbol in this.favourite_symbols) {
            ids.add (symbol.id);
        }

        return ids.to_array ();
    }

    public Symbol ? find_favourite_symbol (string id) {
        foreach (Symbol symbol in this.favourite_symbols) {
            if (symbol.id == id) {
                return symbol;
            }
        }

        return null;
    }
}
