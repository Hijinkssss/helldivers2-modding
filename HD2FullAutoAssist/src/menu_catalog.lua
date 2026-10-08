-- Fixed shipped FAA choices; generated from the audited 1.1.0 selector table.
-- Keep persisted indices stable. New choices may only be appended.
local M={}
M.profiles={
 {key="hyena_profile",weapon="R-4 Hyena",label="Primary: R-4 Hyena",description="Balanced: 120 RPM; Full Auto: 190 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=120},
  {label="Full Auto",value="full_auto",rpm=190},
 }},
 {key="eruptor_profile",weapon="R-36 Eruptor",label="Primary: R-36 Eruptor",description="Balanced / default: 28 RPM; Slower Cadence: 27 RPM; Maximum / native-speed cadence: 32 RPM. Repeats normal Fire; accepted shots remain game-controlled. OFF restores native held-fire behavior.",choices={
  {label="28 RPM - Balanced / default",value="balanced_28",rpm=28},
  {label="27 RPM - Slower Cadence",value="slower_27",rpm=27},
  {label="32 RPM - Maximum / native-speed cadence",value="max_32",rpm=32},
 }},
 {key="peacemaker_profile",weapon="P-2 Peacemaker",label="Secondary: P-2 Peacemaker",description="Balanced: 380 RPM; Full Auto: 900 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=380},
  {label="Full Auto",value="full_auto",rpm=900},
 }},
 {key="socom_profile",weapon="M6C/SOCOM Pistol",label="Secondary: M6C/SOCOM Pistol",description="Balanced: 380 RPM; Full Auto: 900 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=380},
  {label="Full Auto",value="full_auto",rpm=900},
 }},
 {key="veto_profile",weapon="P-69 Veto",label="Secondary: P-69 Veto",description="Balanced: 380 RPM; Full Auto: 750 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=380},
  {label="Full Auto",value="full_auto",rpm=750},
 }},
 {key="talon_profile",weapon="LAS-58 Talon",label="Secondary: LAS-58 Talon",description="Balanced: 210 RPM; Efficiency: 60 RPM; Full Auto: 380 RPM; FULLER AUTO: 750 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=210},
  {label="Efficiency",value="efficiency",rpm=60},
  {label="Full Auto",value="full_auto",rpm=380},
  {label="FULLER AUTO",value="fuller_auto",rpm=750},
 }},
 {key="bushwhacker_profile",weapon="SG-22 Bushwhacker",label="Secondary: SG-22 Bushwhacker",description="Balanced: 90 RPM; Full Auto: 650 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=90},
  {label="Full Auto",value="full_auto",rpm=650},
 }},
 {key="amr_profile",weapon="APW-1 Anti-Materiel Rifle",label="Support: APW-1 Anti-Materiel Rifle",description="Balanced: 120 RPM; Full Auto: 400 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=120},
  {label="Full Auto",value="full_auto",rpm=400},
 }},
 {key="commando_profile",weapon="MLS-4X Commando",label="Support: MLS-4X Commando",description="Balanced: 120 RPM; Full Auto: 240 RPM. Repeats normal Fire; accepted shots remain game-controlled.",choices={
  {label="Balanced",value="balanced",rpm=120},
  {label="Full Auto",value="full_auto",rpm=240},
 }},
}
function M.default_index(def,settings)
 local selected=settings[def.key]
 if def.key=='eruptor_profile' then selected=require('config').eruptor_profile(selected) end
 if not selected or selected=='' then
  if def.key=='eruptor_profile' then selected='balanced_28'
  elseif def.key=='talon_profile' then selected=settings.talon_mode or 'balanced'
  else selected=settings.fire_rate_mode=='native_cap' and 'full_auto' or 'balanced' end
 end
 for index,choice in ipairs(def.choices)do if choice.value==selected then return index end end
 return 1
end
return M
