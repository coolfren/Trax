package trax;

import sys.net.Socket;
import trax.Router.Response;

typedef StartHeader = {
    method:String,
    path:String,
    version:String
}

enum abstract Method(String)
{
    var GET = "GET";
    var POST = "POST";
    var PUT = "PUT";
    var DELETE = "DELETE";
}

class Headers {
    public static function status(code:Int){
        return switch(code){
            case 100:
                "100 Continue";
            case 101:
                "101 Switching Protocols";
            case 102:
                "102 Processing";
            case 103:
                "103 Early Hints";
            case 200:
                "200 OK";
            case 201:
                "201 Created";
            case 202:
                "202 Accepted";
            case 203:
                "202 Non-Authoritative Information";
            case 204:
                "204 No Content";
            case 205:
                "205 Reset Content";
            case 206:
                "206 Partial Content";
            case 207:
                "207 Multi-Status";
            case 300:
                "300 Multiple Choices";
            case 301:
                "301 Moved Permanently";
            case 302:
                "302 Found";
            case 404:
                "404 Not Found";
            case 418:
                "418 I'm a teapot";
            default:
                "400 Bad Request";
        };
    }

    public static function buildHeaders(headers:Array<String>, body:String):String
    {
        var temp = "";
        temp += "HTTP/1.1 ";
        for(head in headers){
            temp += head + "\n";
        }
        temp += "\n" + body;
        return temp;
    };

    public static function headersFromMap(f:Map<String,String>){
        final array = [];
        for(k => v in f)
            array.push('$k: $v');
        return array;
    }

    public static function buildBody(code:Int){
        return '<html>
        <head><title>${status(code)}</title></head>
        <body>
        <center><h1>${status(code)}</h1></center>
        <hr><center>Trax</center>
        </body>
        </html>';
    }
}