// TODO remove Object() from constructors

using Gee;

namespace Markets {
  const string BASE_URL = "https://query1.finance.yahoo.com";

  public class RestClient {
    private Soup.Session session;

    public RestClient () {
      this.session = new Soup.Session();
    }

    public async Json.Node fetch (string url) {
      var message = new Soup.Message("GET", url);

      yield this.queue_message(this.session, message);

      // TODO handle error
      // message.status_code == 200

      var body = (string) message.response_body.data;
      return Json.from_string(body);
    }

    public async void queue_message (Soup.Session session, Soup.Message message) {
      SourceFunc async_callback = queue_message.callback;
      session.queue_message (message, () => { async_callback (); });
      yield;
    }
  }

  public class Service : Object {
    private State state;
    private RestClient client;

    private uint? timeout_id = null;

    public Service (State state) {
      this.state = state;
      this.client = new RestClient();

      this.attach_listeners ();

      this.on_pull_interval_updated ();
    }

    public bool on_tick () {
        this.update.begin((obj, res) => {
          this.update.end(res);
        });

        return true;
    }

    private void attach_listeners () {
        this.state.notify["dark-theme"].connect (this.on_dark_theme_updated);
        this.state.notify["pull-interval"].connect (this.on_pull_interval_updated);
    }

    private void on_dark_theme_updated () {
        Gtk.Settings.get_default().gtk_application_prefer_dark_theme =
            this.state.dark_theme;
    }

    private void on_pull_interval_updated () {
        if (this.timeout_id != null) {
            Source.remove (this.timeout_id);
        }

        var interval = this.state.pull_interval;
      	this.timeout_id = Timeout.add_seconds(interval, this.on_tick);

    }

    public async void search (string query) {
      if (query == null || query.length == 0) {
        this.state.search_results = new ArrayList<Symbol> ();
        return;
      }

      this.state.networkStatus = NetworkStatus.IN_PROGRESS;

      var url = @"$(BASE_URL)/v1/finance/search?q=$query&lang=en-US&region=US&quotesCount=10&newsCount=0&enableFuzzyQuery=false&quotesQueryId=tss_match_phrase_query&enableEnhancedTrivialQuery=true";
      var json = yield this.client.fetch(url);

      var search_results = new ArrayList<Symbol> ();

      var quotes = json.get_object().get_array_member("quotes");
      for (var i = 0; i < quotes.get_length(); i++) {
        var object = quotes.get_object_element(i);
        search_results.add(new Symbol.from_json_object (object));
      }

      this.state.search_results = search_results;

      this.state.networkStatus = NetworkStatus.IDLE;
    }

    public async void update () {
        string ids;
        ids = string.joinv(
            ",",
            this.state.get_favourite_symbol_ids ()
        );
        ids = Soup.URI.encode(ids, ",");

        string fields;
        fields = string.join(
            ",",
            "symbol",
            "marketState",
            "shortName",
            "exchange",
            "regularMarketPrice",
            "regularMarketChange",
            "regularMarketChangePercent",
            "regularMarketTime"
        );
        fields = Soup.URI.encode(fields, ",");

        this.state.networkStatus = NetworkStatus.IN_PROGRESS;

        var url = @"$(BASE_URL)/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&fields=$fields&symbols=$ids";

        var json = yield this.client.fetch(url);

        var objects = json.get_object()
            .get_object_member("quoteResponse")
            .get_array_member("result");
        for (var i = 0; i < objects.get_length(); i++) {
            var object = objects.get_object_element(i);
            var id = object.get_string_member ("symbol");
            this.state.find_favourite_symbol(id).update(object);
        }

        this.state.networkStatus = NetworkStatus.IDLE;

        this.store_favourite_symbols ();
    }

    private string get_config_file () {
        var path = string.join(
            "/",
            Environment.get_user_config_dir (),
            Environment.get_application_name ()
        );

        var config_dir = File.new_for_path (path);
        if (!config_dir.query_exists ()) {
            config_dir.make_directory ();
        }

        return config_dir
            .resolve_relative_path ("favourite-symbols.json")
            .get_path ();
    }

    private void store_favourite_symbols () {
        var path = this.get_config_file ();

        Json.Builder builder = new Json.Builder ();

        builder.begin_object ();

        builder.set_member_name ("version");
	    builder.add_int_value (1);

        builder.set_member_name ("symbols");
        builder.begin_array ();
        foreach (Symbol symbol in this.state.favourite_symbols) {
            symbol.build_json(builder);
        }
        builder.end_array ();

        builder.end_object ();

        Json.Generator generator = new Json.Generator ();
        generator.pretty = true;
	    generator.root = builder.get_root ();
        generator.to_file (path);
    }

    public void load_favourite_symbols () {
        var path = this.get_config_file ();

        Json.Parser parser = new Json.Parser ();

        try {
		    parser.load_from_file (path);
	    } catch (Error e) {
		    warning("The config file doesn't exist. Skipping.");
		    return;
	    }

	    var objects = parser
	        .get_root ()
	        .get_object()
	        .get_array_member("symbols");

        this.state.favourite_symbols.clear ();

        for (var i = 0; i < objects.get_length(); i++) {
            var object = objects.get_object_element(i);
            this.state.favourite_symbols.add (new Symbol.from_json_object (object));
        }
    }
  }
}
