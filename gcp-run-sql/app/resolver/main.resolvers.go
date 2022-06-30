package resolver

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"app/generated"
	"context"
)

func (r *queryResolver) Health(ctx context.Context) (*generated.Message, error) {
	return &generated.Message{Message: "ok"}, nil
}

// Query returns generated.QueryResolver implementation.
func (r *Resolver) Query() generated.QueryResolver { return &queryResolver{r} }

type queryResolver struct{ *Resolver }
