package bank

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	juno "github.com/forbole/juno/v5/types"
)

// HandleMsg implements modules.MessageModule
func (m *Module) HandleMsg(index int, msg sdk.Msg, tx *juno.Tx) error {
	return nil
}

func FindAllEventsByType(index int, tx *juno.Tx, eventType string) []sdk.StringEvent {
	var list []sdk.StringEvent
	for _, ev := range tx.Logs[index].Events {
		if ev.Type == eventType {
			list = append(list, ev)
		}
	}
	return list
}
