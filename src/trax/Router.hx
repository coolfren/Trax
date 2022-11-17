package trax;

import haxe.io.Bytes;
import sys.thread.Thread;
import trax.Headers.StartHeader;
import sys.net.Socket;
import sys.net.Host;
import haxe.io.Mime;
using StringTools;

class Response
{
  public var headers:Map<String, String> = [
    'Connection' => 'closed',
    'Date' => Date.now().toString(),
    'Server' => 'Trax/0.0.1',
    "Content-Type" => Mime.TextHtml
  ];
  public var body:Dynamic;
  public var client:Socket;
  public var statusCode:String = "200 OK";
  public var headersSent:Bool = false;

  public function new(client:Socket){
    this.client = client;
  }

  public function status(code:Int){
    statusCode = Headers.status(code);
    return this;
  }

  public function send(content:String){
    if(headersSent)
      return;
    if(this.body == null)
      this.body = "";
    this.body += content;
    headers.set("Content-Length", Std.string(this.body.length));
  }

  public function sendBytes(bytes:Bytes, type:Mime){
    this.body = bytes;
    this.headers['Content-Type'] = type;
  }

  public function json(content:String){
    headers.set("Content-Type", Mime.ApplicationJson);
    send(content);
  }
}

class Request
{
  public var requestInfo:StartHeader;
  public var headers:Map<String, String> = [];
  public var body:Dynamic;
  public var useragent:String;

  public function new(){}
  public function toString(){
    return 'Information: $requestInfo\nHeaders:$headers\nBody:$body\n';
  }
}

typedef RouteFunction = (Request, Response)->Void;

class Router
{
  private var routes:Map<String, Map<String, RouteFunction>> = [
    "GET" => [],
    "POST" => [],
    "PUT" => [],
    "DELETE" => []
  ];
  private var socket:Socket;
  
  public var onStart:Void->Void;

  public var middleware:Array<RouteFunction> = [];

  public var address = "";
  
  public function new(address:String = "127.0.0.1", ?onStart:Void->Void)
  {
    this.address = address;
    this.onStart = onStart;
  }

  public function use(middleware:RouteFunction){
    this.middleware.push(middleware);
  }

  private function handleConnections(c:Socket){
    var requestH:String = "";
    c.setTimeout(30);
    c.setBlocking(false);
    while(true){
      try{
        final readRe = c.input.readLine();
        requestH += readRe + "\n";
        if(readRe == "")
          break;
      }
      catch(e)
        break;
    }
    //c.write(header);

    final request = new Request();
    final response = new Response(c);

    try{
      final nlreq = requestH.split("\n");
      final start = nlreq[0].split(" ");
      if(start[0] == null || start[1] == null || start[2] == null)
        throw "Null!";
      request.requestInfo = {
        method: start[0],
        path: start[1],
        version: start[2]
      };
      nlreq.pop();
      if(request.requestInfo.method == "GET"){
        final params = request.requestInfo.path.split("?");
        if(params.length > 1){
          request.body = {};
          for(param in params){
            final splitParam = param.split("=");
            Reflect.setField(request.body, splitParam[0], splitParam[1]);
          }
          request.requestInfo.path = params[0];
        }
      }
      for(i in 0...nlreq.length){
        final header = nlreq[i].split(": ");
        request.headers.set(header[0], header[1]);
      }
    }
    catch(e){
      error(c, 400);
      return;
    }

    for(ware in middleware)
      ware(request, response);

    try{
      routes.get(request.requestInfo.method).get(request.requestInfo.path)(request, response);
    }
    catch(e){
      if(!response.headersSent){
        error(c, 404);
        return;
      }
    }
    final headersI = Headers.headersFromMap(response.headers);
    headersI.insert(0, response.statusCode);
    c.write(Headers.buildHeaders(headersI, response.body));
    c.close();
  }

  public function error(c:Socket, code:Int){
    c.write(Headers.buildHeaders([Headers.status(code), "Content-Type: text/html"], Headers.buildBody(code)));
    c.close();
  }

  public function listen(port:Int){
    socket = new Socket();
    socket.bind(new Host(address), port);
    socket.listen(0);
    if(onStart != null)
      onStart();
    while(true){
      final c = socket.accept();
      Thread.create(()->handleConnections(c));
    }
  }

  public function stop(){
    socket.close();
  };

  public function get(route:String, func:RouteFunction)
  {
    routes.get("GET").set(route, func);
  }
  
  public function post(route:String, func:RouteFunction)
  {
    routes.get("POST").set(route, func);
  }
  
  public function put(route:String, func:RouteFunction)
  {
    routes.get("PUT").set(route, func);
  }
  
  public function delete(route:String, func:RouteFunction)
  {
    routes.get("DELETE").set(route, func);
  }
}