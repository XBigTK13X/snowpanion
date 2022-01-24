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

func calculate():
	breakdown = {
		expansion = _expansion.bonus_points,
		parks = 0,
		fences = 0,
		pools = 0,
		temps = 0
	} 
	var park_weight = _ai.points[0]
	var pool_weight = _ai.points[1]
	var temp_weight = _ai.points[2]
	var fence_weight = _ai.points[3]
	var bis_weight = _ai.points[4]
	var estate_weight = _ai.points[5]

	var temp_count = 0

	var estate_scores = []

	var estate = {cards = [], score = 0, has_agent = false}

	for card_index in range(0,_deck.size()):
		var card = _deck[card_index]
		if card._kind == 'fence':
			breakdown.fences += fence_weight
			for estate_card in estate.cards:
				if estate_card._kind == 'bis':
					if estate.has_agent:
						estate.score += bis_weight * estate_weight
					else:				
						estate.score += bis_weight
				else:
					if estate.has_agent:
						estate.score += estate_weight
					else:
						estate.score += 1
			estate_scores.push_back(estate.score)
			estate = {cards = [], score = 0}
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

	if temp_count == 0:
		breakdown.temp_bonus = 0
	elif temp_count >= _player_temp_count:
		breakdown.temp_bonus = 7
	else:
		breakdown.temp_bonus = 4

	breakdown.estates_bonus = 0
	breakdown.estates = []
	estate_scores.sort()
	for ii in range(0,5):
		print("Testing "+str(ii))
	if estate_scores.size() > 5:
		for ii in range(0,5):
			# TODO Should it be 5 or 4? Not sure if Godot is inclusive on range
			print("Scoring AI over 5 estates: "+str(ii))
			breakdown.estates_bonus += estate_scores[estate_scores.size() - ii]
			breakdown.estates.push_front(estate_scores[estate_scores.size() - ii])
	else:
		for score in estate_scores:
			breakdown.estates_bonus += score
			breakdown.estates.push_front(score)

	breakdown.total = breakdown.expansion + breakdown.parks + breakdown.fences + breakdown.pools + breakdown.temps
	breakdown.total += breakdown.temp_bonus + breakdown.estates_bonus
	
	return breakdown

func format_breakdown():
	var formatted_estates = ''
	for estate_index in breakdown.estates.size():
		var estate = breakdown.estates[estate_index]
		formatted_estates += str(estate)
		if estate_index < breakdown.estates.size() - 1:
			formatted_estates += ', '
	var result = ""
	result += 'Parks: ' + str(breakdown.parks) + '\n'
	result += 'Pools: ' + str(breakdown.pools) + '\n'
	result += 'Fences: ' + str(breakdown.fences) + '\n'
	result += 'Temps: ' + str(breakdown.temps) + '\n'
	result += 'Expansion: ' + str(breakdown.expansion) + '\n'
	result += 'Temp Bonus: ' + str(breakdown.temp_bonus) + '\n'
	result += 'Estates: ' + formatted_estates + '\n'
	result += 'Total: '+ str(breakdown.total)
	return result