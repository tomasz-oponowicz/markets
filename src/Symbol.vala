public class Markets.Symbol : Object {
    public bool selected {
        get; set; default = false;
    }

    public string id {
        get; set; default = "";
    }

    public string instrument_type {
        get; set; default = "";
    }

    public string name {
        get; set; default = "";
    }

    public string exchange_name {
        get; set; default = "";
    }

    public string market_state {
        get; set; default = "closed";
    }

    public int precision {
        get; set; default = 2;
    }

    public string currency {
        get; set; default = "";
    }

    public DateTime ? regular_market_time {
        get; set; default = null;
    }

    public double regular_market_price {
        get; set; default = 0;
    }

    public double regular_market_change {
        get; set; default = 0;
    }

    public double regular_market_change_percent {
        get; set; default = 0;
    }

    public bool is_marked_closed {
        get {
            return this.market_state.down () != "regular";
        }
    }

    public Symbol.from_search (Json.Object json) {
        if (json.has_member ("symbol")) {
            this.id = json.get_string_member ("symbol");
        }

        if (json.has_member ("longname")) {
            this.name = json.get_string_member ("longname");
        } else if (json.has_member ("shortname")) {
            this.name = json.get_string_member ("shortname");
        }

        if (json.has_member ("typeDisp")) {
            this.instrument_type = json.get_string_member ("typeDisp");
        } else if (json.has_member ("quoteType")) {
            this.instrument_type = json.get_string_member ("quoteType");
        }

        if (json.has_member ("exchange")) {
            this.exchange_name = json.get_string_member ("exchange");
        }
    }

    public Symbol.from_quote (Json.Object json) {
        if (json.has_member ("symbol")) {
            this.id = json.get_string_member ("symbol");
        }

        this.update (json);
    }

    public Symbol.from_mock (
        string id,
        string name,
        string instrument_type,
        string exchange_name
    ) {
        this.id = id;
        this.name = name;
        this.instrument_type = instrument_type;
        this.exchange_name = exchange_name;
    }

    public void update (Json.Object json) {
        if (json.has_member ("quoteType")) {
            this.instrument_type = json.get_string_member ("quoteType");
        }

        if (json.has_member ("shortName")) {
            this.name = json.get_string_member ("shortName");
        }

        if (json.has_member ("exchange")) {
            this.exchange_name = json.get_string_member ("exchange");
        }

        if (json.has_member ("currency")) {
            this.currency = json.get_string_member ("currency");
        }

        if (json.has_member ("marketState")) {
            this.market_state = json.get_string_member ("marketState");
        }

        if (json.has_member ("priceHint")) {
            this.precision = (int) json.get_int_member ("priceHint");
        }

        if (json.has_member ("regularMarketTime")) {
            this.regular_market_time = new DateTime.from_unix_utc (
                json.get_int_member ("regularMarketTime")
            );
        }

        if (json.has_member ("regularMarketPrice")) {
            this.regular_market_price =
                json.get_double_member ("regularMarketPrice");
        }

        if (json.has_member ("regularMarketChange")) {
            this.regular_market_change =
                json.get_double_member ("regularMarketChange");
        }

        if (json.has_member ("regularMarketChangePercent")) {
            this.regular_market_change_percent =
                json.get_double_member ("regularMarketChangePercent");
        }
    }

    public void build_json (Json.Builder builder) {
        builder.begin_object ();

        builder.set_member_name ("symbol");
        builder.add_string_value (this.id);

        builder.set_member_name ("quoteType");
        builder.add_string_value (this.instrument_type);

        builder.set_member_name ("shortName");
        builder.add_string_value (this.name);

        builder.set_member_name ("exchange");
        builder.add_string_value (this.exchange_name);

        builder.set_member_name ("marketState");
        builder.add_string_value (this.market_state);

        builder.set_member_name ("currency");
        builder.add_string_value (this.currency);

        builder.set_member_name ("priceHint");
        builder.add_int_value (this.precision);

        if (this.regular_market_time != null) {
            builder.set_member_name ("regularMarketTime");
            builder.add_int_value (this.regular_market_time.to_unix ());
        }

        builder.set_member_name ("regularMarketPrice");
        builder.add_double_value (this.regular_market_price);

        builder.set_member_name ("regularMarketChange");
        builder.add_double_value (this.regular_market_change);

        builder.set_member_name ("regularMarketChangePercent");
        builder.add_double_value (this.regular_market_change_percent);

        builder.end_object ();
    }
}
