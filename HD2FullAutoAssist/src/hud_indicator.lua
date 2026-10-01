-- Controller-state projection and retained Stingray GUI. No native memory access.
local M={}
function M.project(state)
    local eligibility=state and state.eligibility or {}
    local weapon=state and state.weapon or {}
    local category=eligibility.category
    return {visible=state~=nil and state.user_enabled==true and state.effective==true and
        state.identity_valid==true and state.identity_observed==true and
        (category=='ASSIST' or category=='SPECIAL' or category=='CHARGE'),
        weapon=weapon.name,resource_hash=weapon.resource_hash,category=category,
        eligible=category=='ASSIST' or category=='SPECIAL',
        user_enabled=state and state.user_enabled==true or false,
        effective=state and state.effective==true or false,
        identity_valid=state and state.identity_valid==true or false}
end
function M.new(engine,options)
    options=options or {}
    local self={available=false,failures=0,created=0,destroyed=0,calls=0,emitted=0,
        force_visible=options.force_visible==true,reason='engine_unavailable'}
    engine=type(engine)=='table' and engine or {}
    local A,W,G=engine.Application or {},engine.World or {},engine.Gui or {}
    self.available=type(A.worlds)=='function' and type(A.main_world)=='function' and
        type(W.create_screen_gui)=='function' and type(W.destroy_gui)=='function' and
        type(G.resolution)=='function' and type(G.rect)=='function' and type(G.update_rect)=='function' and
        type(G.set_visible)=='function' and engine.Vector2~=nil and engine.Vector3~=nil and engine.Color~=nil
    self.reason=self.available and 'ready' or 'engine_api_unavailable'
    local function contains(list,wanted)
        for _,world in ipairs(list)do if world==wanted then return true end end
        return false
    end
    function self:report(model,force)
        if not options.log or self.emitted>=120 then return end
        model=model or {}
        local key=table.concat({tostring(model.resource_hash),tostring(model.visible),tostring(model.category),
            self.reason,tostring(self.created),tostring(self.width),tostring(self.height)},':')
        if not force and key==self.report_key and self.calls~=60 and self.calls%600~=0 then return end
        self.report_key=key;self.emitted=self.emitted+1
        pcall(options.log,{implementation='1.1.0-rc2',renderer_instantiated=true,
            renderer_available=self.available,gui_created=self.gui~=nil,draw_update_calls=self.calls,
            created=self.created,destroyed=self.destroyed,failures=self.failures,reason=self.reason,
            error=self.error,api={worlds=type(A.worlds)=='function',main_world=type(A.main_world)=='function',
                create_screen_gui=type(W.create_screen_gui)=='function',destroy_gui=type(W.destroy_gui)=='function',
                resolution=type(G.resolution)=='function',rect=type(G.rect)=='function',
                update_rect=type(G.update_rect)=='function',set_visible=type(G.set_visible)=='function'},weapon=model.weapon,resource_hash=model.resource_hash,eligible=model.eligible,
            category=model.category,hud_visible=model.visible==true,user_enabled=model.user_enabled,
            effective=model.effective,identity_valid=model.identity_valid,force_visible=self.force_visible,
            world_count=self.world_count,target_index=self.target_index,world=tostring(self.world),
            width=self.width,height=self.height,x=self.x,y=self.y,scale=self.scale,alpha=230,
            layer=900,anchor='screen-bottom-left',parent='independent-screen-gui',
            clipping='viewport-only; no native ammo parent',on_screen=self.on_screen,rectangles=self.ids and #self.ids or 0})
    end
    function self:clear()
        if self.gui then
            local ok,why=pcall(function()
                if contains(A.worlds(),self.world)then
                    G.set_visible(self.gui,false);W.destroy_gui(self.world,self.gui)
                end
            end)
            if not ok then self.failures=self.failures+1;self.error=tostring(why) end
            self.destroyed=self.destroyed+1
        end
        self.gui,self.world,self.ids,self.signature=nil,nil,nil,nil
    end
    function self:present(model)
        self.calls=self.calls+1
        if not self.available then self:report(model);return end
        local good,why=pcall(function()
            if not self.force_visible and (not model or model.visible~=true)then
                self:clear();self.reason='conditional_hidden';return
            end
            local list=A.worlds();assert(type(list)=='table','UI worlds unavailable')
            self.world_count=#list;self.target_index=nil
            local main,target=A.main_world(),nil
            -- Same exposed screen surface selection as KnowYourConstellation/HCR.
            -- RC1 rejected scenes with multiple non-main worlds.
            for index,world in ipairs(list)do
                if world~=main then target=world;self.target_index=index;break end
            end
            if not target then self:clear();self.reason='ui_world_missing';return end
            if self.world and self.world~=target then self:clear()end
            local width,height=G.resolution()
            assert(type(width)=='number' and type(height)=='number' and width>=640 and height>=480 and
                width<32768 and height<32768,'Invalid HUD resolution')
            self.width,self.height=width,height
            if not self.gui then
                self.world=target
                self.gui=assert(W.create_screen_gui(target,'scale',1,1),'FAA GUI unavailable')
                G.set_visible(self.gui,false)
                self.ids={};self.created=self.created+1
            end
            local signature=tostring(width)..':'..tostring(height)
            self.reason=self.force_visible and 'forced_probe' or 'visible'
            if signature==self.signature then return end
            -- Original static yellow 17 by 14 three-cartridge glyph, unchanged.
            local s=height/1080;local x,y=width*.17,height*.09
            if self.force_visible then s=s*4;x=width*.5;y=height*.5 end
            self.x,self.y,self.scale=x,y,s
            self.on_screen=x>=0 and y>=0 and x+17*s<=width and y+14*s<=height
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
            G.set_visible(self.gui,true)
            self.signature=signature
        end)
        if not good then
            self.failures=self.failures+1;self.error=tostring(why);self:clear()
            self.available=false;self.reason='render_error'
        end
        self:report(model)
    end
    self:report(nil,true)
    return self
end
return M
