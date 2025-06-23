package main

import (
	"fmt"
	_ "net/http"
	"github.com/cgmattos/case-devops-globo/src/routes"
	"github.com/cgmattos/case-devops-globo/src/server"
	"github.com/cgmattos/case-devops-globo/src/variables"
)

func main() {
	variables.GetVariables()
	server := server.Server()
	routes.InitRoutes(server)
	server.Logger.Fatal(server.Start(fmt.Sprintf("%s:%s",
		variables.Variables["host"],
		variables.Variables["port"])))
}