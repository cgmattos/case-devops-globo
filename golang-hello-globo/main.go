package main

import (
	"fmt"
	_ "net/http"
	"github.com/cgmattos/case-devops-globo/src/cache"
	"github.com/cgmattos/case-devops-globo/src/routes"
	"github.com/cgmattos/case-devops-globo/src/server"
	"github.com/cgmattos/case-devops-globo/src/variables"
)

func main() {
	// Instancia o struct com as variáveis de ambiente tratadas
	variables.InitVariables()

	//Instancia o servidor Echo
	server := server.Server()

	//Instancia as rotas
	routes.InitRoutes(server)

	//Instancia a conection pool com redis
	cache.InitRedisClient()

	//Cria routine de healthcheck da connection pool, facilitando o uso do cache nas rotas
	go cache.CacheHealthCheck()
	defer cache.RedisClient.Close()

	//Inicia o servidor
	server.Logger.Fatal(server.Start(fmt.Sprintf("%s:%s",
		variables.EnvVars.Host,
		variables.EnvVars.Port,
	)))
}