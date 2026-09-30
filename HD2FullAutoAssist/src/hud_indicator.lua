-- Controller-state projection and a retained Stingray GUI. No memory access.
local M={}
function M.project(state)
    local category=state and state.eligibility and state.eligibility.category
    return {visible=state~=nil and state.user_enabled==true and state.effective==true and
        state.identity_valid==true and state.identity_observed==true and
        (category=='ASSIST' or category=='SPECIAL' or category=='CHARGE')}
end
function M.new(engine)
    local self={available=false,failures=0,created=0,destroyed=0}
    if type(engine)~='table' then return self end
    local A,W,G=engine.Application,engine.World,engine.Gui
    self.available=A and W and G and type(A.worlds)=='function' and type(A.main_world)=='function' and
        type(W.create_screen_gui)=='function' and type(W.destroy_gui)=='function' and
        type(G.resolution)=='function' and type(G.rect)=='function' and type(G.update_rect)=='function' and
        engine.Vector2~=nil and engine.Vector3~=nil and engine.Color~=nil or false
    local function contains(list,wanted)
        for _,world in ipairs(list)do if world==wanted then return true end end
        return false
    end
    function self:clear()
        if self.gui then
            local ok=pcall(function()
                local list=A.worlds()
                if contains(list,self.world)then W.destroy_gui(self.world,self.gui)end
            end)
            if not ok then self.failures=self.failures+1 end
            self.destroyed=self.destroyed+1
        end
        self.gui,self.world,self.ids,self.signature=nil,nil,nil,nil
    end
    function self:present(model)
        if not self.available then return end
        local good=pcall(function()
            if not model or model.visible~=true then self:clear();return end
            local list=A.worlds();assert(type(list)=='table','UI worlds unavailable')
            local main,target=A.main_world(),nil
            -- Only an unambiguous UI world is accepted, never a guessed surface.
            for _,world in ipairs(list)do
                if world~=main then if target then self:clear();return end;target=world end
            end
            if not target then self:clear();return end
            if self.world and self.world~=target then self:clear()end
            local width,height=G.resolution()
            assert(type(width)=='number' and type(height)=='number' and width>=640 and height>=480 and
                width<32768 and height<32768,'Invalid HUD resolution')
            if not self.gui then
                self.world=target
                self.gui=assert(W.create_screen_gui(target,'scale',1,1),'FAA GUI unavailable')
                self.ids={};self.created=self.created+1
            end
            local signature=tostring(width)..':'..tostring(height)
            if signature==self.signature then return end
            -- A static three-cartridge glyph: 17 by 14 UI units, no text.
            -- Defaults need live comparison to the native ammo widget/scale.
            local s=height/1080;local x,y=width*.17,height*.09
            local ink=engine.Color(230,255,213,0)
            for bullet=0,2 do
                for part,shape in ipairs({{1,0,2,2},{0,2,4,9},{1,11,2,3}})do
                    local index=bullet*3+part
                    local pos=engine.Vector3(x+(bullet*6+shape[1])*s,y+shape[2]*s,900)
                    local size=engine.Vector2(shape[3]*s,shape[4]*s)
                    if self.ids[index] then G.update_rect(self.gui,self.ids[index],pos,size,ink)
                    else self.ids[index]=assert(G.rect(self.gui,pos,size,ink),'FAA glyph unavailable')end
                end
            end
            self.signature=signature
        end)
        if not good then self.failures=self.failures+1;self:clear();self.available=false end
    end
    return self
end
-- Inert host for environments without exposed GUI APIs (including fixtures).
local original=M.new
M.new=function(engine)
    local self=original(engine)
    if not self.clear then function self:clear()end end
    if not self.present then function self:present()end end
    return self
end
return M
