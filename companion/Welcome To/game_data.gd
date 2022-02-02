extends Node

var debug_ai_scoring = false

# Points are top->bottom, left column->right column
var solo_ais = {
	cog_1 = {
		goals = [false,false,true], points = [1,1,1,1,2,2], asset="front", atlas_index=2, nudge = Vector2(15,0)
	},
	cog_2 = {
		goals = [true, true, true], points = [3,1,1,1,1,1], asset="back", atlas_index=2, nudge = Vector2(15,0)
	},
	cog_3 = {
		goals = [false,true,false], points = [0,5,3,1,3,2], asset="front", atlas_index=1, nudge = Vector2(5,0)
	},
	cog_4 = {
		goals = [true, false, true], points = [2,3,1,3,2,2], asset="back", atlas_index=1, nudge = Vector2(5,0)
	},
	cog_5 = {
		goals = [true,true,false], points = [1,2,3,3,4,2], asset="front", atlas_index=0, nudge = Vector2(-10,0)
	},
	cog_6 = {
		goals = [false,true,true], points = [4,3,2,2,1,4], asset="back", atlas_index=0, nudge = Vector2(0,5)
	},
	alan = {
		goals = [true, true, true], points = [3,2,1,2,2,2], asset="back", atlas_index=3, nudge = Vector2(-10,10)
	},
	alex = {
		goals = [false,false,false], points = [2,4,1,2,3,2], asset="front", atlas_index=3, nudge = Vector2(0,0)
	},
	ann = {
		goals = [true,false,false], points = [3,5,3,1,4,2], asset="front", atlas_index=4, nudge = Vector2(10,0)
	},
	ben = {
		goals = [true, true, true], points = [3,4,2,3,3,3], asset="back", atlas_index=4, nudge = Vector2(10,10)
	},
}

var expansions = {
	none = {display="None", bonus_points=0, supported=true},
	halloween = {display="Halloween", bonus_points=15, supported=true},	
	doomsday = {display="Nuclear Doomsday", bonus_points=0, supported=false},		
	spring = {display="Spring / Easter", bonus_points=20, supported=true},
	summer = {display="Summer Ice Cream", bonus_points=25, supported=true},
	winter = {display="Winter Wonderland", bonus_points=25, supported=true},
	outbreak = {display="Zombie Outbreak", bonus_points=0, supported=false}
}

var plans = {
	base = [
		{tier=1, max=8, min=4, atlas_index=0},
		{tier=1, max=8, min=4, atlas_index=1},
		{tier=1, max=8, min=4, atlas_index=2},
		{tier=1, max=6, min=3, atlas_index=3},
		{tier=1, max=8, min=4, atlas_index=4},
		{tier=1, max=10, min=6, atlas_index=5},
		{tier=2, max=11, min=6, atlas_index=6},
		{tier=2, max=8, min=4, atlas_index=7},
		{tier=2, max=10, min=6, atlas_index=8},
		{tier=2, max=12, min=7, atlas_index=9},
		{tier=2, max=9, min=5, atlas_index=10},
		{tier=2, max=9, min=5, atlas_index=11},
		{tier=3, max=12, min=7, atlas_index=12},
		{tier=3, max=13, min=7, atlas_index=13},
		{tier=3, max=7, min=3, atlas_index=14},
		{tier=3, max=7, min=3, atlas_index=15},
		{tier=3, max=11, min=6, atlas_index=16},
		{tier=3, max=13, min=7, atlas_index=17},
		# {tier=1, max=8, min=4, atlas_index=18}, -- Solo AI Card
		{tier=2, max=7, min=4, atlas_index=19, advanced = true},
		{tier=2, max=8, min=3, atlas_index=20, advanced = true},
		{tier=1, max=7, min=4, atlas_index=21, advanced = true},
		{tier=2, max=10, min=5, atlas_index=22, advanced = true},
		{tier=1, max=6, min=3, atlas_index=23, advanced = true},
		{tier=2, max=7, min=4, atlas_index=24, advanced = true},
		{tier=1, max=8, min=3, atlas_index=25, advanced = true},
		{tier=1, max=6, min=3, atlas_index=26, advanced = true},
		{tier=2, max=10, min=5, atlas_index=27, advanced = true},
		{tier=1, max=8, min=4, atlas_index=28, advanced = true},
	]
}

var constructions = {
	fence = [1,2,3,5,5,6,6,7,8,8,9,10,10,11,11,13,14,15],
	temp = [3,4,6,7,8,9,10,12,13],
	pool = [3,4,6,7,8,9,10,12,13],
	estate = [1,2,4,5,5,6,7,7,8,8,9,9,10,11,11,12,14,15],
	bis = [3,4,6,7,8,9,10,12,13],
	park = [1,2,4,5,5,6,7,7,8,8,9,9,10,11,11,12,14,15],
}
