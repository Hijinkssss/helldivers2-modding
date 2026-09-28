local Result=require('hd2modcore.result')
local Util=require('hd2modcore.util')

local M={}
local Book={}
Book.__index=Book

function M.new(platform,memory,profiles)
    assert(platform and memory and profiles,'symbol dependencies required')
    return setmetatable({platform=platform,memory=memory,profiles=profiles,
        images={},resolved=0,failures=0},Book)
end

function Book:resolve(name)
    local selected=self.profiles.selected
    if not selected then
        self.failures=self.failures+1
        return Result.err('UnsupportedBuild','symbols','no exact build profile')
    end
    local row=selected.symbols and selected.symbols[name]
    if not row then
        self.failures=self.failures+1
        return Result.err('UnsupportedSymbol','symbols',tostring(name))
    end
    local image=self.images[row.module]
    if not image then
        if type(self.platform.module_address)~='function' or
            type(self.platform.module_image_size)~='function' then
            self.failures=self.failures+1
            return Result.err('AddressResolutionFailed','symbols','module metadata unavailable')
        end
        local base,why=self.platform:module_address(row.module)
        local size,size_why=self.platform:module_image_size(row.module)
        if not Util.integer(base,0x10000,0x7fffffffffff) or
            not Util.integer(size,4096,0x80000000) or
            size>0x7fffffffffff-base then
            self.failures=self.failures+1
            return Result.err('AddressResolutionFailed','symbols',why or size_why or
                'invalid module image')
        end
        image={base=base,size=size}
        self.images[row.module]=image
    end
    if not Util.integer(row.rva,0,image.size-8) then
        self.failures=self.failures+1
        return Result.err('InvalidLayout','symbols','RVA outside module image')
    end
    local address=image.base+row.rva
    local check=self.memory:read(address,8)
    if not check.ok then
        self.failures=self.failures+1
        return Result.err('AddressResolutionFailed','symbols',
            check.error.code..': '..check.error.detail)
    end
    self.resolved=self.resolved+1
    return Result.ok({name=name,address=address,module=row.module,rva=row.rva,
        kind=row.kind,evidence=row.evidence,build_id=selected.id})
end

function Book:clear()
    self.images={}
end

function Book:status()
    return {resolved=self.resolved,failures=self.failures}
end

return M
