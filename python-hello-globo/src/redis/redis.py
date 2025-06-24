from datetime import datetime, timedelta
import json
import redis
from src.config.config import Config
from src.config.app import App

redis_pool = None

def init_redis_pool():
    global redis_pool
    try:
        redis_pool = redis.ConnectionPool(
            host=Config.redis_host,
            port=Config.redis_port,
            db=Config.redis_db
        )
    except Exception as err:
        App.logger.error(f"time: {datetime.now().strftime('%d-%m-%Y %H:%M:%S')} | Erro ao iniciar o pool de conexões com Redis")
        App.logger.debug(err)

def get_cache_data(cache_key):
    if redis_pool:
        App.logger.debug(redis_pool)
        redis_conn = redis.Redis(connection_pool=redis_pool)
        data = redis_conn.get(cache_key)
        return data
    else:
        return None
    
def set_cache_data(cache_key, data):
    if redis_pool:
        App.logger.debug(redis_pool)
        redis_conn = redis.Redis(connection_pool=redis_pool)
        success = redis_conn.setex(
            cache_key,
            timedelta(seconds=int(Config.cache_window)),
            json.dumps(data)
        )

        if success:
            App.logger.info("Cache updated with success")
            return True
        else:
            App.logger.info("Coudn't update cache")
            return False
    else:
        return False