package auth

import (
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	"github.com/forbole/callisto/v4/types"
	"github.com/rs/zerolog/log"
)

// UpdateParams gets the updated params and stores them inside the database
func (m *Module) UpdateParams(height int64) error {
	log.Debug().Str("module", "auth").Int64("height", height).
		Msg("updating params")

	params := authtypes.DefaultParams()

	return m.db.SaveAuthParams(types.NewAuthParams(params, height))
}
