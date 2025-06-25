package thorchain

import (
	"encoding/json"
	"fmt"

	tmtypes "github.com/cometbft/cometbft/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	"github.com/rs/zerolog/log"

	"github.com/forbole/callisto/v4/types"
)

// HandleGenesis implements GenesisModule
func (m *Module) HandleGenesis(doc *tmtypes.GenesisDoc, appState map[string]json.RawMessage) error {
	log.Debug().Str("module", "thorchain").Msg("parsing genesis")

	var genState GenesisState
	err := json.Unmarshal(appState["thorchain"], &genState)
	if err != nil {
		return fmt.Errorf("error while unmarshalling thorchain state: %s", err)
	}

	err = m.saveValidatorsFromNodeAccounts(doc, genState.NodeAccounts)
	if err != nil {
		return fmt.Errorf("error while storing thorchain validators: %s", err)
	}

	return nil
}

func (m *Module) saveValidatorsFromNodeAccounts(doc *tmtypes.GenesisDoc, nodeAccounts []NodeAccount) error {
	validators := make([]types.Validator, 0, len(nodeAccounts))
	validatorDescriptions := make([]types.ValidatorDescription, 0, len(nodeAccounts))
	validatorCommissions := make([]types.ValidatorCommission, 0, len(nodeAccounts))
	validatorStatuses := make([]types.ValidatorStatus, 0, len(nodeAccounts))

	for _, nodeAccount := range nodeAccounts {
		validator, err := m.convertNodeAccountToValidator(doc.InitialHeight, nodeAccount)
		if err != nil {
			log.Warn().Err(err).Str("node_address", nodeAccount.NodeAddress).Msg("failed to convert node account to validator")
			continue
		}
		validators = append(validators, validator)

		stakingDesc := stakingtypes.Description{
			Moniker:         nodeAccount.NodeAddress,
			Identity:        "",
			Website:         "",
			SecurityContact: "",
			Details:         "",
		}
		description := types.NewValidatorDescription(
			validator.GetOperator(),
			stakingDesc,
			"",
			doc.InitialHeight,
		)
		validatorDescriptions = append(validatorDescriptions, description)

		commission := types.NewValidatorCommission(
			validator.GetOperator(),
			nil,
			nil,
			doc.InitialHeight,
		)
		validatorCommissions = append(validatorCommissions, commission)

		status := m.convertNodeAccountStatus(nodeAccount.Status)
		validatorStatus := types.NewValidatorStatus(
			validator.GetConsAddr(),
			validator.GetConsPubKey(),
			status,
			false,
			doc.InitialHeight,
		)
		validatorStatuses = append(validatorStatuses, validatorStatus)
	}

	if len(validators) > 0 {
		err := m.db.SaveValidatorsData(validators)
		if err != nil {
			return fmt.Errorf("error saving validators: %s", err)
		}
	}

	for _, desc := range validatorDescriptions {
		err := m.db.SaveValidatorDescription(desc)
		if err != nil {
			return fmt.Errorf("error saving validator description: %s", err)
		}
	}

	for _, comm := range validatorCommissions {
		err := m.db.SaveValidatorCommission(comm)
		if err != nil {
			return fmt.Errorf("error saving validator commission: %s", err)
		}
	}

	if len(validatorStatuses) > 0 {
		err := m.db.SaveValidatorsStatuses(validatorStatuses)
		if err != nil {
			return fmt.Errorf("error saving validator statuses: %s", err)
		}
	}

	log.Info().Int("count", len(validators)).Msg("saved thorchain validators from genesis")
	return nil
}

func (m *Module) convertNodeAccountToValidator(height int64, nodeAccount NodeAccount) (types.Validator, error) {
	consPubKeyStr := nodeAccount.ValidatorConsPubKey
	if consPubKeyStr == "" {
		return nil, fmt.Errorf("missing validator consensus public key for node %s", nodeAccount.NodeAddress)
	}

	nodeAddr, err := sdk.AccAddressFromBech32(nodeAccount.NodeAddress)
	if err != nil {
		return nil, fmt.Errorf("failed to parse node address %s: %s", nodeAccount.NodeAddress, err)
	}
	
	consAddr := sdk.ConsAddress(nodeAddr[:20])
	
	log.Warn().Str("node_address", nodeAccount.NodeAddress).
		Str("cons_addr", consAddr.String()).
		Msg("using temporary consensus address generation - needs proper thorcpub parsing")

	maxChangeRate := sdk.NewDecWithPrec(1, 2)
	maxRate := sdk.NewDecWithPrec(20, 2)

	return types.NewValidator(
		consAddr.String(),
		nodeAccount.NodeAddress,
		consPubKeyStr, // Use the original pubkey string for now
		nodeAccount.NodeAddress,
		&maxChangeRate,
		&maxRate,
		height,
	), nil
}

func (m *Module) parseConsPubKey(pubKeyStr string) error {
	if len(pubKeyStr) == 0 {
		return fmt.Errorf("empty public key string")
	}
	
	log.Warn().Str("pubkey", pubKeyStr).Msg("THORChain consensus public key parsing not yet implemented")
	
	return fmt.Errorf("consensus public key parsing not implemented for THORChain format: %s", pubKeyStr)
}

func (m *Module) convertNodeAccountStatus(status string) int {
	switch status {
	case "Active":
		return 3
	case "Standby":
		return 2
	case "Disabled":
		return 1
	default:
		return 1
	}
}
