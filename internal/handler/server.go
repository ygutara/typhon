package handler

type Server struct {
	// Repository repository.RepositoryInterface
}

type NewServerOptions struct {
	// Repository repository.RepositoryInterface
}

func NewServer(opts NewServerOptions) *Server {
	return &Server{}
}
