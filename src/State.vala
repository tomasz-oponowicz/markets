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
    public Markets.ViewMode viewMode {
        get;
        set;
        default = Markets.ViewMode.PRESENTATION;
    }

    public Markets.SelectionMode selectionMode {
        get;
        set;
        default = Markets.SelectionMode.NONE;
    }

    public int totalSelected {
        get;
        set;
        default = 0;
    }

    public Markets.NetworkStatus networkStatus {
        get;
        set;
        default = Markets.NetworkStatus.IDLE;
    }

    public ArrayList<Symbol> search_results {
      get;
      set;
      default = new ArrayList<Symbol> ();
    }
}
