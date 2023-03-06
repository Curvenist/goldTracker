Const = {
		Langage = {
			"2", "3"
		},
		Labels = {
			{"myBank", "Capital"}
		},
		CommonTranslations = {
			{"Greet", "Bonjour %player, voici le récapitulatif de votre activité :", "Hello %player, here is your activity summary:"},
			{"Performance", "Performance", "Performance"},
		},
		MenuButtons = {
			{"TrackerCurrent", "Gold Tracker", "Gold Tracker"}, -- default
			{"AdvancedStatOp", "Récapitulatif", "Summary"},
			{"Options", "Configurations", "Configurations"}
			--{"graph", "Graphique"}
		},
		Options = {
			{"GTTitleSegmentation", {"Segmentation du Tracker"}, "label", "%title"},
			{"GTmaxIterations", {"Nombre de jours"}, "EditBox", OptInt:get("GTmaxIterations")},
			{"GTstartingDay", {"Seuil initial"}, "EditBox", OptInt:get("GTstartingDay")},
			{"GTTitleDisplay", {"Affichage Intermittent"}, "label", "%title"},
			{"GTupdateShow", {"Activation"}, "CheckButton", OptInt:get("GTupdateShow")},
			{"GTupdateTimer", {"Durée"}, "EditBox", OptInt:get("GTupdateTimer")},
			{"GTupdateShowType", {"Type"}, "dropdown", OptInt:get("GTupdateShowType"), {{"Complet", "Réduit"}}},
			{"GTTitleSquash", {"Organiser les données"}, "label", "%title"},
			{"GTsquashData", {"Activation"}, "CheckButton", OptInt:get("GTsquashData")},
			{"GTsquashDataType", {"Compartimentage"}, "dropdown", OptInt:get("GTsquashDataType"), {{"Mensuel", "Hebdomadaire"}}}, -- Mensuel / hebdomadaire
			{"GTsquashDataTrigger", {"Seuil de déclenchement"}, "EditBox", OptInt:get("GTsquashDataTrigger")}, -- jours
			{"GTremoveOldData", {"Durée de conservation"}, "EditBox", OptInt:get("GTremoveOldData")}
		},
		-- From here, we have labelling data, works well with MenuM.displayMenuElements, putting nothing in translation will result in having no translation
		MenuItems = {
			{"DailyRecap", "Résumé", "Summary"}, -- afficher en plus : performance moyenne sur 7 jours, moyenne des gains sur 7 jours
			{"Weekly", "Hebdomadaire", "Weekly"},
			{"Monthly", "Mensuelle", "Monthly"},
			{"Compared", "Comparée", "Compared"}, -- basé sur rating, peut fonctionner par fourchette
			{"BookAccount", "Livre de compte", "Book of accounts"}, -- Afficher un tableau avec un sytème de dates, à la fin earnings / dépenses (mettre en vert les jours avec un excedent, en rouge, les jours déficits)
			{"Provisionning", "Budget", "Budget"}, -- bouton permettant de créer un budget de dépense à alluer (chiffre + temporel)
			{"Aim", "Ciblée", "Targeted"} -- bouton permettant de créer un performance cible à réaliser (chiffre + temporel)
		},
        TrackerCurrent = { 
            {"currentMoney", "Epargne", "Savings"},
			{"income", "Revenu", "Income"},
			{"spending", "Dépense", "Spending"},
			{"%drawLine"},
			{"netEarning", "Performance", "Performance"},
			{"%rating", "Perf / moyenne n-1", "Perf / avg n-1"},
			{"%sum", "Cumul Hebdomadaire", "Weekly Cumulative"}
		},
		History = {  -- we will rely on GTMoney -- careful, here object values are not the same in the process, don't rely on it
			{"day", nil},
			{"netEarning", nil},
			{"stat", nil}
		},
		AdvancedStatOp = { --this object should only allow arithmetic values in the end
			{"%outfn:GTM:weekScope", "Hebdomadaire: %value -> %value", "Weekly Summary"}, -- our Week Scope
			{"%fn:Stats:average", "Moyenne", "Average"},
			{"%fn:Stats:plainPerformance", "Somme", "Sum"},
			{"%drawLine"},
			{"%outfn:GTM:monthScope", "Mois courant: %value -> %value", "Monthly Summary"}, -- in any case, our current Month scope
			{"%fn:Stats:average", "Moyenne", "Average"},
			{"%fn:Stats:plainPerformance", "Somme", "Sum"},
			{"%drawLine"},
			{"%outfn:GTM:monthPrevScope", "Mois précédent: %value -> %value", "Monthly Summary Reminder"}, -- this is for checking case we have first week of the month, we get the previous one!
			{"%fn:Stats:average", "Moyenne", "Average"},
			{"%fn:Stats:plainPerformance", "Somme", "Sum"}
		},
		AdvancedStat = {
			{"name", nil},
			{"value", nil},
		},
		ElementDecoration = {
			{"%drawLine"}
		},
		GTMMessage = {
			"Perf Sup!", 
			"Perf Inf!"
		},
		GTMDecoration = {
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
4 = ita
5 = spa
6 = Deu
5 = RU
]]