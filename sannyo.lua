--- STEAMODDED HEADER
--- MOD_NAME: Komakusa Cards
--- MOD_ID: SANNYO
--- MOD_AUTHOR: [AvilionAMillion]
--- MOD_DESCRIPTION: Adds jokers and cards themed around the Touhou Project
--- VERSION: 1.1-alpha

------------- MOD CODE ------------------
sendDebugMessage('Komakusa Cards Initializing')
-- Atlas Setup

SMODS.Atlas {
	key = "jokeratlas",
	path = "sannyojokers.png", 
	px = 71, 
	py = 95,
}

SMODS.Atlas {
	key = "enhancementatlas",
	path = "sannyoenhancements.png", 
	px = 71, 
	py = 95,
}

SMODS.Atlas({key = "modicon", path = "sannyo_icon.png", px = 34, py = 34}):register()

-- Jokers
SMODS.Joker {  -- Donation Box
    key = 'donation',
    loc_txt = {
        name = 'Donation Box',
        text = {'{C:green}#1# in 2{} chance to gain',
        '{C:money}$#2#{} when round ends'}
    },
    config = {extra = {money = 6}},
    rarity = 2,
    pos = {x = 0,y = 0},
    atlas = 'jokeratlas',
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.money}}
    end,
	calc_dollar_bonus = function(self)
		if pseudorandom('donation') < G.GAME.probabilities.normal/2
			then
				local bonus = self.config.extra.money
				return bonus
		end
	end
}

SMODS.Joker {  -- Dream Seal
    key = 'dreamseal',
    loc_txt = {
        name = 'Dream Seal',
        text = {'If {C:attention}first hand{} of round',
		'has only {C:attention}1{} card, turn the played',
		'card into an {C:attention}Ofuda card{}.'}
    },
    config = {mult = 1},
    rarity = 1,
    pos = {x = 1,y = 0},
    atlas = 'jokeratlas',
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {vars = {}}
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local eval = function() return G.GAME.current_round.hands_played == 0 end
		end
		if context.cardarea == G.jokers then
			if context.before then
				if G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
					for i,v in ipairs(context.full_hand)
                            do context.full_hand[i]:set_ability(G.P_CENTERS.m_sann_ofuda, nil, true)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        context.full_hand[i]:juice_up()
                                        return true
									end
                                })) 
					end
						return {
							message = "Sealed!",
							colour = G.C.MULT,
							card = self,
						}
				end
			end
        end
    end
}

SMODS.Joker {  -- Mini Hakkero
    key = 'minihakkero',
    loc_txt = {
        name = 'Mini Hakkero',
        text = {'{C:green}#1# in #2#{} chance to {C:attention}destroy{}',
        'a random scored card.',
		'Permanently increase payout by {C:money}$#3#{}',
		'when card is destroyed.',
		'{C:inactive}(Currently earn{} {C:money}$#4#{} {C:inactive}at end of round.){}' }
    },
    config = {extra = {odds = 8, money_mod = 1, money = 1}},
    rarity = 3,
    pos = {x = 2,y = 0},
    atlas = 'jokeratlas',
    cost = 9,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
	loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds, center.ability.extra.money_mod, center.ability.extra.money}}
    end,
    calculate = function(self, card, context)
        if context.destroying_card and pseudorandom('minihakkero') < G.GAME.probabilities.normal/self.config.extra.odds and not context.blueprint and not context.repetition then
            card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
        return true end
    end,
	calc_dollar_bonus = function(self, card)
		if card.ability.extra.money > 0 then
			return card.ability.extra.money
		end
	end
}

SMODS.Joker {  -- Midnight Bird
    key = 'midnightbird',
    loc_txt = {
        name = 'Midnight Bird',
        text = {'Retrigger all played cards',
		'of {C:spades}Spade{} suit'}
    },
    config = {extra = {repetitions = 1}},
    rarity = 2,
    pos = {x = 3,y = 0},
    atlas = 'jokeratlas',
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	loc_vars = function(self, info_queue)
        return {vars = {self.config.extra.repetitions}}
	end,
	calculate = function(self, card, context)
		if context.repetition then
			if context.cardarea == G.play then
				if context.other_card:is_suit("Spades") then
					return {
					message = localize('k_again_ex'),
					repetitions = self.config.extra.repetitions,
					card = card
					}
				end
			end
		end
	end
}

SMODS.Joker {  -- Baka
    key = 'baka',
    loc_txt = {
        name = 'Baka',
        text = {'{C:chips}+#1#{} Chips.',
		'{C:inactive}Baka.{}'}
    },
    config = {extra = {chips = 9}},
    rarity = 1,
    pos = {x = 4,y = 0},
    atlas = 'jokeratlas',
    cost = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and not context.before and not context.after then
			return {
				message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }),
				chip_mod = card.ability.extra.chips,
			}
		end
	end
}

SMODS.Joker {  -- Teh Strongest Jimbo
    key = 'baka2',
    loc_txt = {
        name = 'TEH STRONGEST JIMBO',
        text = {'{C:chips}+#1#{} Chips.',
		'{C:inactive}Baka?{}'}
    },
    config = {extra = {chips = 999}},
    rarity = 3,
    pos = {x = 5,y = 0},
    atlas = 'jokeratlas',
    cost = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
	end,
	in_pool = function(self)
		return next(SMODS.find_card('j_sann_baka'))
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and not context.before and not context.after then
			return {
				message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }),
				chip_mod = card.ability.extra.chips,
			}
		end
	end
}

-- ENHANCEMENTS

SMODS.Enhancement { -- Ofuda Card
	key = 'ofuda',
	atlas = 'enhancementatlas',
	pos = {x=0, y=0},
	config = { x_mult = 1.25, h_mult = 4 },
	loc_txt = {
		name = 'Ofuda Card',
		text = {'{X:mult,C:white} X#1# {} Mult when scored',
			'{C:mult}+#2#{} Mult when held in hand.',
			'no rank or suit.'}
		},
		no_rank = true,
		no_suit = true,
		replace_base_card = true,
		always_scores = true,
		loc_vars = function(self, info_queue)
			return { vars = {self.config.x_mult, self.config.h_mult}}
		end
	}

sendDebugMessage('Komakusa Cards Finished Loading!')




