-- Exchange
Const = {
		Langage = {
			"2", "3"
		},
		Labels = {
			{"myBank", "Capital"}
		},
		MenuItems = {
			{"DailyRecap", "Résumé du jour"}, -- afficher en plus : performance moyenne sur 7 jours, moyenne des gains sur 7 jours
			{"WeeklyRecap", "Performance hebdomadaire"}, -- graph
			{"MonthlyRecap", "Performance mensuelle"}, -- graph
			{"ComparedPerformance", "Performances comparées"}, -- basé sur rating, peut fonctionner par fourchette
			{"BookAccount", "Livre de compte"}, -- Afficher un tableau avec un sytème de dates, à la fin earnings / dépenses (mettre en vert les jours avec un excedent, en rouge, les jours déficits)
			{"Provisionning", "Budgétisation"}, -- bouton permettant de créer un budget de dépense à alluer (chiffre + temporel)
			{"CibledAim", "Performance ciblée"} -- bouton permettant de créer un performance cible à réaliser (chiffre + temporel)
		},
        Exchange = {
            {"date", "Date"},
            {"dailyMoney", "Crédit jour"},
            {"currentMoney", "Crédit courant"},
			{"netEarning", "Résultat net"},
            {"income", "Recette"},
            {"spending", "Dépenses"},
            {"netDailyValue", "Solde hors act. / jour"},
            {"netValue", "Solde hors act. auj."}
		}
}

--Langage list
--[[
2 = fr
3 = en
]]