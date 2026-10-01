local Fixture=require('native_transition_fixture')
local Policy=require('weapon_policy')
local Native=require('native_fire')
local ffi=require('ffi')
local function f32(bytes)local v=ffi.new('float[1]');ffi.copy(v,bytes,4);return tonumber(v[0])end
-- Narrow executable model of exact-build 0x12fc180, NOT a weapon/game emulator.
-- r8+16 becomes xmm7; magnitude threshold gates held-time accumulation;
-- trigger 8 emits the press edge or modulo crossing. +4 remains physical
-- magnitude, +0 is the transient pulse, +8 is held time. dt is native float.
local function step(old,new,period,dt)
    local elapsed=f32(ffi.string(ffi.new('float[1]',old.seconds+dt),4))
    local pulse
    if old.seconds==0 then pulse=math.abs(old.magnitude)<.5 and math.abs(new)>=.5
    else local rem=elapsed%period;pulse=math.abs(old.magnitude)>=.5 and math.abs(new)>=.5 and rem>=0 and rem-dt<0 end
    local seconds=0
    if math.abs(new)>=period and math.abs(old.magnitude)>=period then seconds=elapsed end
    return {magnitude=new,seconds=seconds,pulse=pulse}
end
-- B2 assertion accepts these floats, but the real updater cannot sustain a hold.
for _,requested in ipairs({60/32,60/50})do
    local row={magnitude=0,seconds=0};local pulses=0
    for _=1,2000 do row=step(row,1,requested,1/120);if row.pulse then pulses=pulses+1 end end
    assert(pulses==1 and row.seconds==0,'B2 must reproduce initial-only native Fire')
end
local profiles={{'05e4e5c2db6e44a2','peacemaker_profile',{'balanced','full_auto'}},
 {'4d58c77087b774c5','socom_profile',{'balanced','full_auto'}},
 {'c780bcd79547da0f','veto_profile',{'balanced','full_auto'}},
 {'416d053372c4e433','talon_profile',{'balanced','efficiency','full_auto','fuller_auto'}},
 {'89c5493e08ca4207','amr_profile',{'balanced','full_auto'}},
 {'5990123d142b16cb','commando_profile',{'balanced','full_auto'}},
 {'e5796355a8fd67e0','hyena_profile',{'balanced','full_auto'}},
 {'2b28e17ffed05f7c','bushwhacker_profile',{'balanced','full_auto'}},
 {'b6aff2195568767f','eruptor_profile',{'slower_27','balanced_28','max_32'}}}
local cases={}
for _,mode in ipairs({'balanced','native_cap'})do
    local p=Policy.new(mode)
    -- All supported identities, including Eruptor, Crossbow and the minimum RPM.
    for _,hash in ipairs({'05e4e5c2db6e44a2','4d58c77087b774c5','c780bcd79547da0f',
        '1a437158e1b8d2a1','03e67a19b07c6523','4c786785c79d44e7','0f83639ab8c86165',
        '416d053372c4e433','89c5493e08ca4207','7b75e5132ffd4ca6','e6d932be83729076',
        'e5796355a8fd67e0','f0338468dcdb6a6c','41eac4a03987faa0','4f749e2ee26f532d',
        '4e310b1fe4c52b52','d323de60855898ac','90ddc374f4e3d756','c12a34f375bd5a87',
        'f49227a0630a3f7f','b6aff2195568767f','05d8d8c073b9d502','1abbff60d26ba391',
        '80f1a156d9fa1e36','8d3d52a3b2f19402','d6b1fb05b9109353','2b28e17ffed05f7c',
        '0b882808c6f498e8','dbb6c961c59fadc1','cf8934ff6567a42d','5990123d142b16cb'})do
        cases[#cases+1]={hash=hash,config='fire_rate_mode='..mode,seconds=p:classify(hash).repeat_seconds}
    end
end
for _,entry in ipairs(profiles)do for _,profile in ipairs(entry[3])do
    cases[#cases+1]={hash=entry[1],config=entry[2]..'='..profile,
        seconds=Policy.new('balanced','balanced',{[entry[2]]=profile}):classify(entry[1]).repeat_seconds}
end end
assert(#cases==83)
for _,case in ipairs(cases)do
    local f=Fixture.new(case.config);f:weapon(case.hash);f:fire(true);f:tick()
    assert(f.backend.lease and f.backend.repeat_seconds==case.seconds)
    local period=f32(f:bytes(f.BUCKET+24,4))
    assert(period>0 and period<=1)
    if case.seconds<=1 then assert(math.abs(period-case.seconds)<1e-6,'Previously working cadence changed')end
    local row={magnitude=0,seconds=0};local pulses,last_accepted,accepted=0,-math.huge,0
    local dt=1/120;local duration=math.max(4,case.seconds*6)
    for i=1,math.ceil(duration/dt)do
        row=step(row,1,period,dt)
        f:input(row.magnitude,row.seconds,row.pulse,8,0);f:tick(dt*1000000)
        assert(f.backend.lease,'A long cadence must not expire a held lease')
        if row.pulse then
            pulses=pulses+1
            -- Simulated cooldown only establishes that retries cannot bypass
            -- a stock rate gate. It does not prove actual accepted shot timing.
            local now=i*dt
            if now-last_accepted>=case.seconds then
                last_accepted=now;accepted=accepted+1
            end
        end
    end
    assert(pulses>=3 and accepted>=3,'Native retry signal must continue across multiple slow cycles')
    row=step(row,0,period,dt);assert(row.seconds==0 and not row.pulse)
    f:input(0,0,false,8);f:tick(dt*1000000)
    assert(not f.backend.lease and f:restored(),'Release within a long cadence must restore immediately')
    assert(f.consumer:stop().ok)
end
-- Release just before/at/after requested cadence boundaries, then rapid taps.
for _,requested in ipairs({60/32,60/50,1,60/380})do
    for _,offset in ipairs({-1/120,0,1/120})do
        local f=Fixture.new();f:weapon('b6aff2195568767f');f:fire(true);f:tick()
        f:tick((requested+offset)*1000000);f:fire(false);f:tick(1000)
        assert(not f.backend.lease and f:restored() and not f.consumer:status().wait_release)
        f:fire(true);f:tick(1000);assert(f.backend.lease)
        f:fire(false);f:tick(1000);assert(f:restored())
        assert(f.consumer:stop().ok)
    end
end
assert(Native.native_period(60/32)==.9375 and Native.native_period(60/50)==.6)
for _,mode in ipairs({'balanced','native_cap'})do
    local p=Policy.new(mode)
    local e=p:classify('b6aff2195568767f')
    assert(e.max_repeat_rpm==28 and e.repeat_seconds==60/28 and e.repeat_ms==2143)
    assert(p:classify('7b75e5132ffd4ca6').max_repeat_rpm==60,'Constitution unchanged')
    assert(p:classify('f49227a0630a3f7f').max_repeat_rpm==50,'Crossbow unchanged')
    assert(p:classify('d323de60855898ac').max_repeat_rpm==80,'Cookout unchanged')
    assert(p:classify('416d053372c4e433').max_repeat_rpm==210,'Talon unchanged')
    assert(p:classify('1a437158e1b8d2a1').max_repeat_rpm==(mode=='balanced' and 380 or 450),'Verdict unchanged')
    assert(Policy.new(mode,'balanced',{eruptor_profile='full_auto'}):classify('b6aff2195568767f').max_repeat_rpm==32)
end
assert(math.abs(Native.native_period(60/27)-20/27)<1e-12,'Existing divided retry calculation retained')
print('B3 native threshold replay: '..#cases..' policy/profile cases, long holds, release and boundary taps passed')
