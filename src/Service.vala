// TODO remove Object() from constructors

using Gee;

namespace Markets {
  const string BASE_URL = "https://finnhub.io/api/v1";

  public enum Category {
    STOCK,
    FOREX,
    CRYPTO
  }

  public class Exchange : Object {
    public string id {
      get; private set;
    }

    public Category category {
      get; private set;
    }

    public string name {
      get; private set;
    }

    public Exchange (string id, Category category, string name) {
      this.id = id;
      this.category = category;
      this.name = name;
    }
  }

  public class Symbol : Object {
    public string id {
      get; private set;
    }

    public string name {
      get; private set;
    }

    public Exchange exchange {
      get; private set;
    }

    public Symbol(Exchange exchange) {
      this.exchange = exchange;
    }

    public Symbol.fromJsonObject(Exchange exchange, Json.Object json) {
      this(exchange);

      this.id = json.get_string_member("symbol");
      this.name = this.exchange.category == Category.STOCK
          ? json.get_string_member("description")
          : json.get_string_member("displaySymbol");
    }
  }

  public class Tick : Object {
    public double price {
      get;
      set;
    }

    public double change {
      get;
      set;
    }

    public bool is_market_open {
      get;
      set;
    }

    public Symbol symbol {
      get;
      set;
    }
  }

  public class RestClient {
    private Soup.Session session;

    public RestClient () {
      this.session = new Soup.Session();
    }

    public async Json.Node fetch (string url) {
      var message = new Soup.Message("GET", url);

      // TODO make it generic
      message.request_headers.append("X-Finnhub-Token", "bri9qdnrh5rep8a5ivi0");

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

    public Service (State state) {
      this.state = state;
      this.client = new RestClient();
    }

    public void load_async () {
      this.load.begin((obj, res) => {
        this.load.end(res);
      });
    }

    private async void load () {
      Category[] categories = new Category[] {
        Category.STOCK,
        Category.FOREX,
        Category.CRYPTO
      };

      this.state.networkStatus = NetworkStatus.IN_PROGRESS;

      for (var i = 0; i < categories.length; i++) {
        var exchanges = yield this.load_exchanges(categories[i]);
        for (var j = 0; j < exchanges.size; j++) {
          var symbols = yield this.load_symbols(exchanges[j]);
          this.state.symbols.add_all(symbols);
        }
      }

      print("==> loaded\n");

      this.state.networkStatus = NetworkStatus.IDLE;
    }

    private async ArrayList<Exchange> load_exchanges (Category category) {
      var exchanges = new ArrayList<Exchange>();

      if (category == Category.STOCK) {
        exchanges.add(new Exchange("US", Category.STOCK, "NASDAQ"));
      } else {
        string path = this.to_path(category);
        var url = @"$(BASE_URL)/$(path)/exchange";
        var json = yield this.client.fetch(url);

        var items = json.get_array();
        for (var i = 0; i < items.get_length(); i++) {
          var id = items.get_string_element(i);
          exchanges.add(new Exchange(id, category, id));
        }
      }

      return exchanges;
    }

    private async ArrayList<Symbol> load_symbols (Exchange exchange) {
      var symbols = new ArrayList<Symbol>();

      string path = this.to_path(exchange.category);
      var url = @"$(BASE_URL)/$(path)/symbol?exchange=$(exchange.id)";
      var json = yield this.client.fetch(url);

      var items = json.get_array();
      for (var i = 0; i < items.get_length(); i++) {
        var object = items.get_object_element(i);
        symbols.add(new Symbol.fromJsonObject(exchange, object));
      }

      return symbols;
    }

    private string to_path (Category category) {
      string path = "";

      switch (category) {
        case Category.STOCK:
          path = "stock";
          break;
        case Category.FOREX:
          path = "forex";
          break;
        case Category.CRYPTO:
          path = "crypto";
          break;
      }

      return path;
    }
  }
}
