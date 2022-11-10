<img src="md/trax.svg">

# Trax
Trax is a web framework for Haxe similar to Express.

This project is still work in progress. Expect missing features. (Pull requests are always welcome!)

## TODO
- [ ] Implement middleware
- [ ] Implement parsing of GET parameters and POST bodies

## Example
```haxe
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
```