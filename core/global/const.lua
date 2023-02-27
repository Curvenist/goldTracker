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
		MenuButtons = {
			{"TrackerCurrent", "Gold Tracker"}, -- default
			{"Options", "Configurations"},
			{"AdvancedStatOp", "Récapitulatif"}
			--{"graph", "Graphique"}
		},
		Options = {
			{"isSquashing", "Regroupement des anciennes données"}
		},
		-- From here, we have labelling data, works well with MenuM.displayMenuElements, putting nothing in translation will result in having no translation
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
			{"income", "Revenu"},
			{"spending", "Dépense"},
			{"%drawLine"},
			{"netEarning", "Performance"},
			{"%rating", "Perf / moyenne n-1"},
			{"%sum", "Cumul Hebdomadaire"}
		},
		History = {  -- we will rely on customMoney -- careful, here object values are not the same in the process, don't rely on it
			{"day", nil},
			{"netEarning", nil},
			{"stat", nil}
		},
		AdvancedStatOp = { --this object should only allow arithmetic values in the end
			{"%outfn:CMM:weekScope", "Récapitulatif Hebdomadaire"}, -- our Week Scope
			{"%fn:Stats:average", "Moyenne"},
			{"%fn:Stats:plainPerformance", "Somme"},
			{"%drawLine"},
			{"%outfn:CMM:monthScope", "Récapitulatif mensuel"}, -- in any case, our current Month scope
			{"%fn:Stats:average", "Moyenne"},
			{"%fn:Stats:plainPerformance", "Somme"},
			{"%drawLine"},
			{"%outfn:CMM:monthPrevScope", "Rappel de récapitulatif mensuel"}, -- this is for checking case we have first week of the month, we get the previous one!
			{"%fn:Stats:average", "Moyenne"},
			{"%fn:Stats:plainPerformance", "Somme"}
		},
		AdvancedStat = {
			{"name", nil},
			{"value", nil},
		},
		ElementDecoration = {
			{"%drawLine"}
		},
		CMMMessage = {
			"Perf Sup!", 
			"Perf Inf!"
		},
		CMMDecoration = {
			"%value",
			"%value%",
			"+%value%",
			"%value(/%mult)",
		}
}

--Langage list
--[[
2 = fr
3 = en
]]