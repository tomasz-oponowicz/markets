namespace Markets {
    const string BASE_URL = "https://query1.finance.yahoo.com";

    public class Service : Object {
        private RestClient client;
        private Settings settings;
        private uint ? timeout_id = null;

        public Service () {
            this.state = new State ();
            this.client = new RestClient ();
            this.settings = new Settings ("com.bitstower.Markets");
        }

        private void attach_listeners () {
            this.bind_setting ("dark-theme", "dark_theme");
            this.bind_setting ("pull-interval", "pull_interval");
            this.bind_setting ("window-width", "window_width");
            this.bind_setting ("window-height", "window_height");

            this.state.notify["symbols"].connect (this.on_symbols_updated);
            this.state.notify["dark-theme"].connect (this.on_dark_theme_updated);
            this.state.notify["pull-interval"].connect (this.on_pull_interval_updated);
            this.state.notify["search-query"].connect (this.on_search_query_updated);
            this.state.notify["link"].connect (this.on_link_updated);
        }

        public State state {
            get; private set;
        }

        public void init () {
            this.attach_listeners ();

            this.load_symbols ();
            this.on_pull_interval_updated ();
            this.on_dark_theme_updated ();
        }

        private void bind_setting (string setting_prop, string state_prop) {
            this.settings.bind (
                setting_prop,
                this.state,
                state_prop,
                SettingsBindFlags.DEFAULT
            );
        }

        private void on_symbols_updated () {
            this.on_tick ();
        }

        private bool on_tick () {
            this.update.begin ((obj, res) => {
                this.update.end (res);
            });

            return true;
        }

        private void on_search_query_updated () {
            this.search.begin (this.state.search_query, (obj, res) => {
                this.search.end (res);
            });
        }

        private void on_link_updated () {
            if (this.state.link == null) {
                return;
            }

            try {
                Gtk.show_uri_on_window (null, this.state.link, Gdk.CURRENT_TIME);
            } catch (Error e) {
                warning (@"An error occured when opening the link, message: $(e.message)");
            }

            // reset value in order to allow triggering the same url many times
            this.state.link = null;
        }

        private void on_dark_theme_updated () {
            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme =
                this.state.dark_theme;
        }

        private void on_pull_interval_updated () {
            if (this.timeout_id != null) {
                Source.remove (this.timeout_id);
            }

            var interval = this.state.pull_interval;
            this.timeout_id = Timeout.add_seconds (interval, this.on_tick);
        }

        private async void search (string query) {
            if (query == null || query.length == 0) {
                this.state.search_results = new Gee.ArrayList<Symbol> ();
                return;
            }

            this.state.network_status = State.NetworkStatus.IN_PROGRESS;

            var url = @"$BASE_URL/v1/finance/search" +
                      @"?q=$query" +
                      "&lang=en-US" +
                      "&region=US" +
                      "&quotesCount=10" +
                      "&newsCount=0" +
                      "&enableFuzzyQuery=false" +
                      "&quotesQueryId=tss_match_phrase_query" +
                      "&enableEnhancedTrivialQuery=true";

            var json = yield this.client.fetch (url);

            var search_results = new Gee.ArrayList<Symbol> ();

            var quotes = json.get_object ().get_array_member ("quotes");
            for (var i = 0; i < quotes.get_length (); i++) {
                var object = quotes.get_object_element (i);
                search_results.add (new Symbol.from_search (object));
            }

            this.state.search_results = search_results;

            this.state.network_status = State.NetworkStatus.IDLE;
        }

        private async void update () {
            if (this.state.symbols.size == 0) {
                warning ("No symbols. Skipping the update operation.");
                return;
            }

            string ids;
            ids = string.joinv (
                ",",
                this.state.get_symbol_ids ()
            );
            ids = Soup.URI.encode (ids, ",");

            string fields;
            fields = string.join (
                ",",
                "symbol",
                "marketState",
                "quoteType",
                "shortName",
                "exchange",
                "currency",
                "priceHint",
                "regularMarketPrice",
                "regularMarketChange",
                "regularMarketChangePercent",
                "regularMarketTime"
            );
            fields = Soup.URI.encode (fields, ",");

            this.state.network_status = State.NetworkStatus.IN_PROGRESS;

            var url = @"$BASE_URL/v7/finance/quote" +
                      "?lang=en-US" +
                      "&region=US" +
                      "&corsDomain=finance.yahoo.com" +
                      @"&fields=$fields" +
                      @"&symbols=$ids";

            var json = yield this.client.fetch (url);

            var objects = json.get_object ()
                           .get_object_member ("quoteResponse")
                           .get_array_member ("result");
            for (var i = 0; i < objects.get_length (); i++) {
                var object = objects.get_object_element (i);
                var id = object.get_string_member ("symbol");
                this.state.find_symbol (id).update (object);
            }

            this.state.network_status = State.NetworkStatus.IDLE;

            this.store_symbols ();
        }

        private string get_config_file () {
            var path = string.join (
                "/",
                Environment.get_user_config_dir (),
                Environment.get_application_name ()
            );

            var config_dir = File.new_for_path (path);
            if (!config_dir.query_exists ()) {
                config_dir.make_directory ();
            }

            return config_dir
                    .resolve_relative_path ("symbols.json")
                    .get_path ();
        }

        private void store_symbols () {
            var path = this.get_config_file ();

            Json.Builder builder = new Json.Builder ();

            builder.begin_object ();

            builder.set_member_name ("version");
            builder.add_int_value (1);

            builder.set_member_name ("symbols");
            builder.begin_array ();
            foreach (Symbol symbol in this.state.symbols) {
                symbol.build_json (builder);
            }
            builder.end_array ();

            builder.end_object ();

            Json.Generator generator = new Json.Generator ();
            generator.pretty = true;
            generator.root = builder.get_root ();
            generator.to_file (path);
        }

        private void load_symbols () {
            try {
                var path = this.get_config_file ();

                Json.Parser parser = new Json.Parser ();

                parser.load_from_file (path);

                var objects = parser
                               .get_root ()
                               .get_object ()
                               .get_array_member ("symbols");

                var symbols = new Gee.ArrayList<Symbol> ();
                for (var i = 0; i < objects.get_length (); i++) {
                    var object = objects.get_object_element (i);
                    symbols.add (new Symbol.from_quote (object));
                }

                this.state.symbols = symbols;
            } catch (Error e) {
                warning ("The config file doesn't exist. Adding default symbols.");

                this.state.symbols = new Gee.ArrayList<Symbol>.wrap ({
                    new Symbol.from_mock (
                        "TSLA",
                        "EQUITY",
                        "Tesla, Inc.",
                        "NMS"
                    ),
                    new Symbol.from_mock (
                        "BTC-USD",
                        "CRYPTOCURRENCY",
                        "Bitcoin USD",
                        "CCC"
                    ),
                    new Symbol.from_mock (
                        "EURUSD=X",
                        "CURRENCY",
                        "EUR/USD",
                        "CCY"
                    )
                });
            }
        }
    }
}
