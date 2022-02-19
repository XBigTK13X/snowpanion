var PlanCard = SC.Assets.instance('plan-card')

var GameData = SC.Assets.game_data()

var _cards = []

func _init(expansion, plan_tier):
	for plan in GameData.plans[expansion]:
		if(plan.tier == plan_tier):
			_cards.push_back(PlanCard.new(expansion, plan))

func get_all_cards():
	return _cards