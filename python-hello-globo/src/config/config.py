import os

class Config:
    redis_url = os.getenv('REDIS_URL', None)
    port = os.getenv('PORT', '8080')
    host = os.getenv('HOST', '0.0.0.0')
    debug_mode = False
    if os.getenv('DEBUG_MODE', "").lower() == 'true':
        debug_mode = True
