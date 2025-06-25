import os

class Config:
    redis_host = os.getenv('REDIS_HOST', None)
    redis_port = os.getenv('REDIS_PORT', None)
    redis_db = os.getenv('REDIS_DB', 0)
    cache_window = os.getenv("CACHE_WINDOW_SECONDS", 1)
    cache_key = os.getenv("CACHE_KEY", "python_app")
    port = os.getenv('PORT', '8080')
    host = os.getenv('HOST', '0.0.0.0')
    message = os.getenv("MESSAGE", "OLá, Globo!")
    debug_mode = False
    if os.getenv('DEBUG_MODE', "").lower() == 'true':
        debug_mode = True
