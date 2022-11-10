package;

import trax.Router;

class Main {
  static function main() {
    final address = "127.0.0.1";
    final port = 3000;

    final app = new Router(address, ()->{
      trace('Server is listening on http://$address:$port/');
    });

    app.get("/", (req, res)->{
      res.send("Hello World!\n");
      res.send("Your Useragent: " + req.headers.get("User-Agent"));
    });
    
    app.listen(port);
  }
}