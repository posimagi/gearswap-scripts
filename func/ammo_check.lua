_SPECIAL_AMMO = T{
	"Aeolus Arrow",
	"Animikii Bullet",
	"Hauksbok Arrow",
	"Hauksbok Bolt",
	"Hauksbok Bullet",
}

function ammo_check(spell)
	if _SPECIAL_AMMO:contains(player.equipment.ammo) then
		add_to_chat(8, spell.name.." aborted because special ammo is equipped.")
		cancel_spell()
	end
end
