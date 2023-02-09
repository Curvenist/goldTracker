Const = {
		Langage = {
			"2", "3"
		},
		Labels = {
			{"myBank", "Capital"}
		},
		CommonTranslations = {
			{"Greet", "Bonjour %player, voici le récapitulatif de votre activité :"},
			{"Performance", "Performance"},
		},
		-- From here, we have labelling data, works well with MenuM.displayTrackerElements, putting nothing in translation will result in having no translation
		MenuItems = {
			{"DailyRecap", "Résumé"}, -- afficher en plus : performance moyenne sur 7 jours, moyenne des gains sur 7 jours
			{"Weekly", "Hebdomadaire"}, -- graph
			{"Monthly", "Mensuelle"}, -- graph
			{"Compared", "Comparée"}, -- basé sur rating, peut fonctionner par fourchette
			{"BookAccount", "Livre de compte"}, -- Afficher un tableau avec un sytème de dates, à la fin earnings / dépenses (mettre en vert les jours avec un excedent, en rouge, les jours déficits)
			{"Provisionning", "Budget"}, -- bouton permettant de créer un budget de dépense à alluer (chiffre + temporel)
			{"Aim", "ciblée"} -- bouton permettant de créer un performance cible à réaliser (chiffre + temporel)
		},
        TrackerCurrent = { 
            {"currentMoney", "Liquidités"},
			{"netEarning", "Performance"},
		},
		TrackerPast = {  -- we will rely on customMoney
			{"values", nil} -- no text
		}
}

--Langage list
--[[
2 = fr
3 = en
]]