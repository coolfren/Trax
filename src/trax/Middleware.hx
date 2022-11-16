package trax;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.io.Mime;
import trax.Router.RouteFunction;
using StringTools;

class Middleware
{
    public static function json():RouteFunction
    {
        return function parseJson(req, res){
            if(req.headers.get('Content-Type') != Mime.ApplicationJson)
                return;
            req.body = Json.parse(req.body);
        }
    }

    public static function serve(directory:String):RouteFunction
    {
        return function serveDirectory(req, res){
            req.requestInfo.path = req.requestInfo.path.replace("../", ""); // sanitization
            if(!FileSystem.exists('$directory${req.requestInfo.path}'))
                return;
            try{
                res.send(File.getContent('$directory${req.requestInfo.path}'));
                res.headersSent = true;
            }
            catch(e)
            {

            }
        }
    }
}