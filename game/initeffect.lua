function init_effect()

	local effect
	local moonshine=require("lib.moonshine")
	effect=moonshine(moonshine.effects.scanlines)
	effect.chain(moonshine.effects.crt)
	effect.chain(moonshine.effects.chromasep)
	effect.crt.distortionFactor={1.03,1.03}
	effect.scanlines.width=2
	effect.scanlines.opacity=0.7
	effect.chromasep.angle=0.5
	effect.chromasep.radius=2
	return effect
end
