-- Callback/persistence surface with the installed API's Apply/get/set contract.
local M={}
function M.new(saved,refuse,callback_refuse)
    saved=saved or {}
    local f={saved=saved,values={},specs={},callbacks={},registrations=0,gets=0,sets=0,calls=0}
    local function valid(spec,value)
        if spec.type=='toggle' then return type(value)=='boolean' end
        return type(value)=='number' and value==value and value%1==0 and value>=1 and value<=#spec.choices
    end
    local api={api=1,version=3,max_options=32}
    function api.register_option(id,spec)
        f.registrations=f.registrations+1
        if f.registrations==refuse then return false,'fixture refusal' end
        assert(not f.specs[id],'duplicate registration')
        assert(spec.mod=='Full Auto Assist' and spec.mod_id=='codex.full_auto_assist')
        assert(#spec.label<=64 and #spec.description<=400)
        assert(spec.type=='toggle' or spec.type=='choice','fixed options only')
        assert(valid(spec,spec.default))
        if spec.type=='choice' then assert(#spec.choices>=2 and #spec.choices<=16)end
        f.specs[id]=spec
        if valid(spec,saved[id]) then f.values[id]=saved[id] else f.values[id]=spec.default end
        return true
    end
    function api.get(id)f.gets=f.gets+1;return f.values[id]end
    function api.set(id,value)
        assert(valid(f.specs[id],value));f.sets=f.sets+1
        f.values[id]=value;saved[id]=value -- Flush snapshot of menu-owned storage.
        return true
    end
    function api.on_change(id,callback)
        f.calls=f.calls+1
        if f.calls==callback_refuse then return false end
        assert(not f.callbacks[id]);f.callbacks[id]=callback;return true
    end
    function f:apply(id,value)
        assert(valid(self.specs[id],value));self.values[id]=value;saved[id]=value
        assert(self.callbacks[id])(value)
    end
    f.api=api
    return f
end
return M
