public class Markets.Symbol : Object {
    public enum MarketState {
        OPEN,
        CLOSED
    }

    public string id {
      get; private set;
    }

    public string instrument_type {
      get; private set;
    }

    public string name {
      get; private set;
    }

    public string exchange_name {
      get; private set;
    }

    public MarketState market_state {
      get; private set;
    }

    public DateTime regular_market_time {
      get; private set;
    }

    public double regular_market_price {
      get; private set;
    }

    public double regular_market_change {
      get; private set;
    }

    public double regular_market_change_percent {
      get; private set;
    }

    public void update(Json.Object json) {
      this.id = json.get_string_member("symbol");

      if (json.has_member("longname")) {
        this.name = json.get_string_member("longname");
      } else if (json.has_member("shortname")) {
        this.name = json.get_string_member("shortname");
      } else {
        this.name = "";
      }

      if (json.has_member("exchange")) {
        this.exchange_name = json.get_string_member("exchange");
      } else {
        this.exchange_name = "";
      }

      if (json.has_member("typeDisp")) {
        this.instrument_type = json.get_string_member("typeDisp");
      } else {
        this.instrument_type = "";
      }

      // this.regular_market_price =
      //   json.get_double_member("regularMarketPrice");
      // this.regular_market_change =
      //   json.get_double_member("regularMarketChange");
      // this.regular_market_change_percent =
      //   json.get_double_member("regularMarketChangePercent");
      // this.regular_market_time =
      //   new DateTime.from_unix_utc (json.get_int_member("regularMarketTime"));
    }

    public Symbol.from_json_object (Json.Object json) {
        this.update(json);
    }
  }
