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
            case 303:
                "303 See Other";
            case 304:
                "304 Not Modified";
            case 305:
                "305 Use Proxy";
            case 306:
                "306 unused";
            case 307:
                "307 Temporary Redirect";
            case 308:
                "308 Permanent Redirect";
            case 400:
                "400 Bad Request";
            case 401:
                "401 Unauthorized";
            case 402:
                "402 Payment Required";
            case 403:    
                "403 Forbidden";
            case 404:
                "404 Not Found";
            case 405:
                "405 Method Not Allowed";
            case 406:
                "406 Not Acceptable";
            case 407:
                "407 Proxy Authentication Required";
            case 408:
                "408 Request Timeout";
            case 409:
                "409 Conflict";
            case 410:
                "410 Gone";
            case 411:
                "411 Length Required";
            case 412:
                "412 Precondition Failed";
            case 413:
                "413 Payload Too Large";
            case 414:
                "414 URI Too Long";
            case 415:
                "415 Unsupported Media Type";
            case 416:
                "416 Range Not Satisfiable";
            case 417:
                "417 Expectation Failed";
            case 418:
                "418 I'm a teapot";
            case 421:
                "421 Misdirected Request";
            case 425:
                "425 Too Early";
            case 426:
                "426 Upgrade Required";
            case 428:
                "428 Precondition Required";
            case 429:
                "429 Too Many Requests";
            case 431:
                "431 Request Header Fields Too Large";
            case 451:
                "451 Unavailable For Legal Reasons";
            case 500:
                "500 Internal Server Error";
            case 501:
                "501 Not Implemented";
            case 502:
                "502 Bad Gateway";
            case 503:
                "503 Service Unavailable";
            case 504:
                "504 Gateway Timeout";
            case 505:
                "505 HTTP Version Not Supported";
            case 506:
                "506 Variant Also Negotiates";
            case 510:
                "510 Not Extended";
            case 511:
                "511 Network Authentication Required";
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