package main

import (
	"github.com/ygutara/typhon/internal/generated"
	"github.com/ygutara/typhon/internal/handler"

	// "github.com/ygutara/typhon/internal/repository"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()

	var server generated.ServerInterface = newServer()

	generated.RegisterHandlers(e, server)
	e.Use(middleware.Logger())
	e.Logger.Fatal(e.Start(":1323"))
}

func newServer() *handler.Server {
	// ini repo for useccase
	// dbDsn := os.Getenv("DATABASE_URL")
	// var repo repository.RepositoryInterface = repository.NewRepository(repository.NewRepositoryOptions{
	// 	Dsn: dbDsn,
	// })
	opts := handler.NewServerOptions{
		// Repository: repo, // assign usecase
	}
	return handler.NewServer(opts)
}
