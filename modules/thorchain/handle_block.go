package thorchain

import (
	"encoding/hex"
	"fmt"

	"github.com/cosmos/cosmos-sdk/types/bech32"
	sdk "github.com/cosmos/cosmos-sdk/types"
	tmctypes "github.com/cometbft/cometbft/rpc/core/types"
	tmtypes "github.com/cometbft/cometbft/types"
	juno "github.com/forbole/juno/v5/types"
	"github.com/rs/zerolog/log"

	"github.com/forbole/callisto/v4/types"
)

// HandleBlock implements BlockModule
func (m *Module) HandleBlock(
	block *tmctypes.ResultBlock, res *tmctypes.ResultBlockResults, _ []*juno.Tx, vals *tmctypes.ResultValidators,
) error {
	log.Debug().Str("module", "thorchain").Int64("height", block.Block.Height).
		Msg("processing block")

	err := m.saveValidatorVotingPowers(block.Block.Height, vals.Validators)
	if err != nil {
		return fmt.Errorf("error while saving validator voting powers: %s", err)
	}

	return nil
}

func (m *Module) saveValidatorVotingPowers(height int64, validators []*tmtypes.Validator) error {
	if len(validators) == 0 {
		return nil
	}

	var votingPowers []types.ValidatorVotingPower
	for _, validator := range validators {
		consAddr, err := m.convertValidatorAddressToConsensus(validator.Address)
		if err != nil {
			log.Warn().Err(err).Str("validator_address", hex.EncodeToString(validator.Address)).
				Msg("failed to convert validator address to consensus address")
			continue
		}

		votingPower := types.NewValidatorVotingPower(
			consAddr,
			validator.VotingPower,
			height,
		)
		votingPowers = append(votingPowers, votingPower)
	}

	if len(votingPowers) > 0 {
		err := m.db.SaveValidatorsVotingPowers(votingPowers)
		if err != nil {
			return fmt.Errorf("error while saving validators voting powers: %s", err)
		}
	}

	log.Debug().Str("module", "thorchain").Int64("height", height).
		Int("count", len(votingPowers)).Msg("saved validator voting powers")

	return nil
}

func (m *Module) convertValidatorAddressToConsensus(validatorAddr []byte) (string, error) {
	if len(validatorAddr) == 0 {
		return "", fmt.Errorf("empty validator address")
	}

	consAddr := sdk.ConsAddress(validatorAddr)
	bech32Addr, err := bech32.ConvertAndEncode("thorvalcons", consAddr)
	if err != nil {
		return "", fmt.Errorf("failed to convert to bech32: %s", err)
	}

	return bech32Addr, nil
}
