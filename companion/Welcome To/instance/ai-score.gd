extends Node

var _ai
var _deck
var _expansion
var _objectives
var _player_temp_count

var breakdown

func init(ai, expansion, objectives, deck, player_temp_count):
	_ai = ai    
	_expansion  = expansion
	_objectives = objectives
	_deck = deck
	_player_temp_count = player_temp_count

func score_estate(estate, bis_weight, estate_weight):
	var house_count = 0
	for estate_card in estate.cards:
		if estate_card._kind == 'bis':
			house_count += bis_weight
		else:
			house_count += 1
	if estate.has_agent:
		return house_count * estate_weight
	return house_count

func calculate():
	breakdown = {
		expansion = _expansion.bonus_points,
		parks = 0,
		fences = 0,
		pools = 0,
		temps = 0,
		top_five_estates = null
	} 
	var park_weight = _ai.points[0]
	var pool_weight = _ai.points[1]
	var temp_weight = _ai.points[2]
	var fence_weight = _ai.points[3]
	var bis_weight = _ai.points[4]
	var estate_weight = _ai.points[5]

	var temp_count = 0

	var estate_scores = []

	var estate = {cards = [], has_agent = false}

	for card_index in range(0,_deck.size()):
		var card = _deck[card_index]
		if card._kind == 'fence':
			breakdown.fences += fence_weight			
			estate_scores.push_back(score_estate(estate, bis_weight, estate_weight))
			estate = {cards = [], has_agent = false}
		else:
			estate.cards.push_back(card)			
		if card._kind == 'pool':
			breakdown.pools += pool_weight
		elif card._kind == 'temp':
			breakdown.temps += temp_weight
			temp_count += 1
		elif card._kind == 'park':
			breakdown.parks += park_weight
		elif card._kind == 'estate':
			estate.has_agent = true

	# Score the final estate
	estate_scores.push_back(score_estate(estate, bis_weight, estate_weight))

	if temp_count == 0:
		breakdown.temp_bonus = 0
	elif temp_count >= _player_temp_count:
		breakdown.temp_bonus = 7
	else:
		breakdown.temp_bonus = 4

	breakdown.estates_bonus = 0
	breakdown.estates = []	

	for score in estate_scores:
		breakdown.estates_bonus += score
		breakdown.estates.push_back(score)

	if estate_scores.size() > 5:
		var sorted_estate_scores = SC.Clone.deep(estate_scores)
		sorted_estate_scores.sort()
		breakdown.estate_bonus = 0
		breakdown.top_five_estates = []		
		for ii in range(0,5):
			breakdown.estates_bonus += sorted_estate_scores[sorted_estate_scores.size() - ii - 1]
			breakdown.top_five_estates.push_back(sorted_estate_scores[sorted_estate_scores.size() - ii - 1])

	breakdown.total = breakdown.expansion + breakdown.parks + breakdown.fences + breakdown.pools + breakdown.temps
	breakdown.total += breakdown.temp_bonus + breakdown.estates_bonus

	breakdown.taken_cards = _deck.size()
	
	return breakdown

func format_breakdown():
	var formatted_estates = ''
	for estate_index in breakdown.estates.size():
		var estate = breakdown.estates[estate_index]
		formatted_estates += str(estate)
		if estate_index < breakdown.estates.size() - 1:
			formatted_estates += ', '
	var result = ""
	result += 'Total Score: '+ str(breakdown.total) + '\n'
	result += 'Expansion: ' + str(breakdown.expansion) + '\n'
	result += 'Parks: ' + str(breakdown.parks) + '\n'
	result += 'Pools: ' + str(breakdown.pools) + '\n'
	result += 'Fences: ' + str(breakdown.fences) + '\n'
	result += 'Temps: ' + str(breakdown.temps) + '\n'	
	result += 'Player Temps: ' + str(_player_temp_count) + '\n'
	result += 'Temp Bonus: ' + str(breakdown.temp_bonus) + '\n'
	result += 'Estates:\n  ' + formatted_estates + '\n'
	if(breakdown.top_five_estates != null):
		var formatted_top_five_estates = ''
		for estate_index in breakdown.top_five_estates.size():
			var estate = breakdown.top_five_estates[estate_index]
			formatted_top_five_estates += str(estate)
			if estate_index < breakdown.top_five_estates.size() - 1:
				formatted_top_five_estates += ', '
		result += 'Scored Estates:\n  ' + formatted_top_five_estates + '\n'
	result += 'Cards Taken: '+str(breakdown.taken_cards)
	return result
