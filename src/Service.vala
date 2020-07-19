using Gee;

namespace Markets {
    const string BASE_URL = "https://query1.finance.yahoo.com";

    public class Service : Object {
        private State state;
        private RestClient client;
        private Settings settings;

        private uint ? timeout_id = null;

        public Service (State state) {
            this.state = state;
            this.client = new RestClient ();
            this.settings = new Settings ("com.bitstower.Markets");

            this.attach_listeners ();
        }

        public bool on_tick () {
            this.update.begin ((obj, res) => {
                this.update.end (res);
            });

            return true;
        }

        private void attach_listeners () {
            this.bind_setting ("dark-theme", "dark_theme");
            this.bind_setting ("pull-interval", "pull_interval");
            this.bind_setting ("window-width", "window_width");
            this.bind_setting ("window-height", "window_height");

            this.state.notify["dark-theme"].connect (this.on_dark_theme_updated);
            this.state.notify["pull-interval"].connect (this.on_pull_interval_updated);
            this.state.notify["search-query"].connect (this.on_search_query_updated);
        }

        private void bind_setting (string setting_prop, string state_prop) {
            this.settings.bind (
                setting_prop,
                this.state,
                state_prop,
                SettingsBindFlags.DEFAULT
            );
        }

        public void on_search_query_updated () {
            this.search.begin (this.state.search_query, (obj, res) => {
                this.search.end (res);
            });
        }

        public void on_dark_theme_updated () {
            Gtk.Settings.get_default ().gtk_application_prefer_dark_theme =
                this.state.dark_theme;
        }

        public void on_pull_interval_updated () {
            if (this.timeout_id != null) {
                Source.remove (this.timeout_id);
            }

            var interval = this.state.pull_interval;
            this.timeout_id = Timeout.add_seconds (interval, this.on_tick);
        }

        public async void search (string query) {
            if (query == null || query.length == 0) {
                this.state.search_results = new ArrayList<Symbol> ();
                return;
            }

            this.state.network_status = NetworkStatus.IN_PROGRESS;

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

            var search_results = new ArrayList<Symbol> ();

            var quotes = json.get_object ().get_array_member ("quotes");
            for (var i = 0; i < quotes.get_length (); i++) {
                var object = quotes.get_object_element (i);
                search_results.add (new Symbol.from_json_object (object));
            }

            this.state.search_results = search_results;

            this.state.network_status = NetworkStatus.IDLE;
        }

        public async void update () {
            string ids;
            ids = string.joinv (
                ",",
                this.state.get_favourite_symbol_ids ()
            );
            ids = Soup.URI.encode (ids, ",");

            string fields;
            fields = string.join (
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
            fields = Soup.URI.encode (fields, ",");

            this.state.network_status = NetworkStatus.IN_PROGRESS;

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
                this.state.find_favourite_symbol (id).update (object);
            }

            this.state.network_status = NetworkStatus.IDLE;

            this.store_favourite_symbols ();
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
                symbol.build_json (builder);
            }
            builder.end_array ();

            builder.end_object ();

            Json.Generator generator = new Json.Generator ();
            generator.pretty = true;
            generator.root = builder.get_root ();
            generator.to_file (path);
        }

        public void load_favourite_symbols () {
            try {
                var path = this.get_config_file ();

                Json.Parser parser = new Json.Parser ();

                parser.load_from_file (path);

                var objects = parser
                               .get_root ()
                               .get_object ()
                               .get_array_member ("symbols");

                var symbols = new ArrayList<Symbol> ();
                for (var i = 0; i < objects.get_length (); i++) {
                    var object = objects.get_object_element (i);
                    symbols.add (new Symbol.from_json_object (object));
                }

                this.state.favourite_symbols = symbols;
            } catch (Error e) {
                warning ("The config file doesn't exist. Adding default symbols.");

                this.state.favourite_symbols = new ArrayList<Symbol>.wrap ({
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
