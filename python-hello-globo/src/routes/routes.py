from flask import Flask, json, Response
from datetime import datetime

def routes(app: Flask):

    @app.route("/hello")
    def get_hello():
        data = json.dumps({"language": "Python", "message":"Olá, Globo!"}, ensure_ascii=False)
        app.logger.info(f"time: {datetime.now().strftime('%d-%m-%Y %H:%M:%S')} | /hello - Status 200 ")
        return Response(data, content_type="application/json; charset=utf-8")
    
    @app.route("/time")
    def get_time():
        data = json.dumps(
            {"language": "Python", "time": datetime.now().strftime('%d-%m-%Y %H:%M:%S')},
            ensure_ascii=False
        )
        app.logger.info(f"time:{datetime.now().strftime('%d-%m-%Y %H:%M:%S')} | /time - Status 200 ")
        return Response(data, content_type="application/json; charset=utf-8")
        
