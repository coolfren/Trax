<img src="md/trax.svg">

# Trax
Trax is a web framework for Haxe similar to Express.

This project is still work in progress. Expect missing features. (Pull requests are always welcome!)

## TODO
- [x] Implement middleware
- [x] Implement parsing of GET parameters and POST bodies (partially)
- [ ] More features

## Example
```haxe
package;

import trax.Middleware;
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
      res.send("Your Useragent: " + req.headers.get("User-Agent") + "\n");
      if(req.body.foo == "bar")
        res.send("foobar!");
    });

    app.listen(port);
  }
}
```