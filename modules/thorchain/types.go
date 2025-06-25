package thorchain

import (
	"encoding/json"
)

type GenesisState struct {
	NodeAccounts   []NodeAccount   `json:"node_accounts"`
	Reserve        string          `json:"reserve"`
	ChainContracts []ChainContract `json:"chain_contracts"`
}

func (gs *GenesisState) ProtoMessage() {}

func (gs *GenesisState) Reset() {
	*gs = GenesisState{}
}

func (gs *GenesisState) String() string {
	data, _ := json.Marshal(gs)
	return string(data)
}

type NodeAccount struct {
	NodeAddress           string    `json:"node_address"`
	Status                string    `json:"status"`
	PubKeySet             PubKeySet `json:"pub_key_set"`
	ValidatorConsPubKey   string    `json:"validator_cons_pub_key"`
	Bond                  string    `json:"bond"`
	ActiveBlockHeight     string    `json:"active_block_height"`
	BondAddress           string    `json:"bond_address"`
	StatusSince           string    `json:"status_since,omitempty"`
	SignerMembership      []string  `json:"signer_membership"`
	RequestedToLeave      bool      `json:"requested_to_leave,omitempty"`
	ForcedToLeave         bool      `json:"forced_to_leave,omitempty"`
	LeaveScore            string    `json:"leave_score,omitempty"`
	IPAddress             string    `json:"ip_address"`
	Version               string    `json:"version"`
	SlashPoints           string    `json:"slash_points,omitempty"`
	Jail                  Jail      `json:"jail,omitempty"`
	CurrentAward          string    `json:"current_award,omitempty"`
	ObserveChains         []Chain   `json:"observe_chains,omitempty"`
	PreflightStatus       string    `json:"preflight_status,omitempty"`
}

type PubKeySet struct {
	Secp256k1 string `json:"secp256k1"`
	Ed25519   string `json:"ed25519"`
}

type Jail struct {
	NodeAddress   string `json:"node_address"`
	ReleaseHeight string `json:"release_height"`
	Reason        string `json:"reason"`
}

type Chain struct {
	Chain  string `json:"chain"`
	Height string `json:"height"`
}

type ChainContract struct {
	Chain   string `json:"chain"`
	Router  string `json:"router,omitempty"`
}

func (gs *GenesisState) UnmarshalJSON(data []byte) error {
	type Alias GenesisState
	aux := &struct {
		*Alias
	}{
		Alias: (*Alias)(gs),
	}
	return json.Unmarshal(data, &aux)
}
