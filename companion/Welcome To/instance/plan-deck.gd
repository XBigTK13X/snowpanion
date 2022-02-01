var PlanCard = load('res://companion/Welcome To/instance/plan-card.gd')

var GameData = SC.Assets.game_data("Welcome To")

var _cards = []

func _init(expansion, plan_tier):
	for plan in GameData.plans[expansion]:
		if(plan.tier == plan_tier):
			_cards.push_back(PlanCard.new(expansion, plan))

func get_all_cards():
	return _cards