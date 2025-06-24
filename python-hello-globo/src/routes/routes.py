from flask import Flask, json, Response
from datetime import datetime
from src.config.config import Config
from src.redis.redis import get_cache_data, set_cache_data

def routes(app: Flask):

    @app.route("/hello")
    def get_hello():
        data = json.dumps({"language": "Python", "message":"Olá, Globo!"}, ensure_ascii=False)
        app.logger.info(f"time: {datetime.now().strftime('%d-%m-%Y %H:%M:%S')} | /hello - Status 200 ")
        return Response(data, content_type="application/json; charset=utf-8")
    
    @app.route("/time")
    def get_time():
        data = get_cache_data(Config.cache_key)
        if not data:
            data = json.dumps(
                {"language": "Python", "time": datetime.now().strftime('%d-%m-%Y %H:%M:%S')},
                ensure_ascii=False
            )
            set_cache_data(Config.cache_key, data)
        else:
            data = json.loads(data)
        app.logger.info(f"time:{datetime.now().strftime('%d-%m-%Y %H:%M:%S')} | /time - Status 200 ")
        return Response(data, content_type="application/json; charset=utf-8")
        
