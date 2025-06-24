import logging
from src.config.config import Config
from src.redis.redis import init_redis_pool
from src.config.app import App
from src.routes.routes import routes
from waitress import serve

def main():
    # Import as configurações
    config = Config()

    # Instancia connection pool do redis
    init_redis_pool()
    
    # Instancia as rotas
    routes(App)

    # Seta os logs e nível de log
    level = logging.INFO
    if config.debug_mode:
        level = logging.DEBUG
    logging.basicConfig(
        level=level,
        format='%(asctime)s %(levelname)s %(name)s %(message)s'
    )

    # Inicia aplicação
    serve(App, host=config.host, port=config.port)

if __name__ == "__main__":
    main()