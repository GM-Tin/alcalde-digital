extends RefCounted

const ROLE_NAMES := ["Ciudadano", "Periodista", "Influencer", "Candidato a alcalde"]

static func assign_roles(player_count: int) -> Array:
	if player_count < 1 or player_count > 4:
		push_error("La partida admite de 1 a 4 jugadores.")
		return []
	var roles: Array = ROLE_NAMES.duplicate()
	roles.shuffle()
	var assignments: Array = []
	for _player_index in range(player_count):
		assignments.append([])
	if player_count == 1:
		assignments[0] = ROLE_NAMES.duplicate()
	elif player_count == 2:
		# Keep the journalist and influencer on different players. The other
		# two roles fill the remaining slot on each player at random.
		var journalist_player := randi_range(0, 1)
		var influencer_player := 1 - journalist_player
		assignments[journalist_player].append("Periodista")
		assignments[influencer_player].append("Influencer")
		var remaining_roles := ["Ciudadano", "Candidato a alcalde"]
		remaining_roles.shuffle()
		assignments[journalist_player].append(remaining_roles[0])
		assignments[influencer_player].append(remaining_roles[1])
	elif player_count == 3:
		var double_role_player := randi_range(0, 2)
		# Any pair is allowed except Journalist + Influencer.
		var allowed_pairs: Array = [
			["Ciudadano", "Periodista"],
			["Ciudadano", "Influencer"],
			["Ciudadano", "Candidato a alcalde"],
			["Periodista", "Candidato a alcalde"],
			["Influencer", "Candidato a alcalde"]
		]
		allowed_pairs.shuffle()
		var double_roles: Array = allowed_pairs[0]
		assignments[double_role_player] = double_roles.duplicate()
		var remaining_roles: Array = ROLE_NAMES.duplicate()
		for role in double_roles:
			remaining_roles.erase(role)
		remaining_roles.shuffle()
		var single_players: Array[int] = []
		for player_index in range(player_count):
			if player_index == double_role_player:
				continue
			single_players.append(player_index)
		if randi_range(0, 1) == 0:
			assignments[single_players[0]] = [remaining_roles[0]]
			assignments[single_players[1]] = [remaining_roles[1]]
		else:
			assignments[single_players[0]] = [remaining_roles[1]]
			assignments[single_players[1]] = [remaining_roles[0]]
	else:
		for player_index in range(player_count):
			assignments[player_index] = [roles[player_index]]
	return assignments
