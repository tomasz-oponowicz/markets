public class Markets.RestClient {
    private Soup.Session session;

    public RestClient () {
        this.session = new Soup.Session ();
    }

    public async Json.Node fetch (string url) {
        var message = new Soup.Message ("GET", url);

        yield this.queue_message (this.session, message);

        if (message.status_code < 200 || message.status_code >= 300) {
            warning (@"Unexpected response: $(message.status_code) $(message.reason_phrase)");
        }

        var body = (string) message.response_body.data;
        return Json.from_string (body);
    }

    public async void queue_message (Soup.Session session, Soup.Message message) {
        SourceFunc async_callback = queue_message.callback;
        session.queue_message (message, () => { async_callback (); });
        yield;
    }
}
