--[[
 角色相关的服务
]]

CharacterKeeper = {}

local self = CharacterKeeper

self.root = nil
self.characters = {}
self.junctors = {}

-- 创建角色
function CharacterKeeper.CreateCharacter(id, sync, team, index, onLoaded)
    local c = Config.Character[id]
    local ac = Config.Avatar[c.avatar]
    local path = ac.path

    local onFinished = function (prefab)
        local go = GameObject.Instantiate(prefab)
        go.transform:SetParent(self.root, false)
        go.name = c.name .. id

        go.transform:SetParent(go.transform, false)
        go.transform.localPosition = Vector3.zero
        
        local entity = Entity(go.name)
        local cfgSkills = {}

        -- 最后一个普通攻击
        if c.genericAtk then
            cfgSkills[#cfgSkills+1] = Config.Skill[c.genericAtk]
        end

        entity:AddBlock(Creature:New({id = id}))
        entity:AddBlock(Avatar:New({config = ac, gameObject = go.transform:Find('Avatar').gameObject}))
        entity:AddBlock(Animation:New({gameObject = go.transform:Find('Animation').gameObject}))
        entity:AddBlock(Location:New({gameObject = go}))
        entity:AddBlock(CharacterAI:New({gameObject = go.transform:Find('AI').gameObject, team = team, index = index}))
        entity:AddBlock(Skill:New({skills = cfgSkills}))
        entity:AddBlock(MoveTo:New())
        entity:AddBlock(Cast:New())

        if onLoaded then
            onLoaded(entity)
        end
    end

    if sync then
        ResourceManager:LoadAsset(path, onFinished)
    else
        ResourceManager:LoadAssetAsync(path, onFinished)
    end
end

function CharacterKeeper.Reset()
    for i = 1, #self.characters do
        local characters = self.characters[i]

        for j = 1, #characters do
            characters[j].destroyed = true
        end
    end

    for _, v in pairs(self.junctors) do
        v:Destroy()
    end
    
    self.characters = {}
    self.junctors = {}
    self.root = nil
end

-- 添加角色到战斗中
function CharacterKeeper.AddCharacter(creature, team, index)
    local char = creature.entity
    local characters = self.characters[team]
    if not characters then
        characters = {}
        self.characters[team] = characters
    end

    characters[index] = char

    print('add junctor (characterAI, battleAI)')

    self.junctors[char] = Junctor('battle+character+' .. team .. '+' .. index, {char.characterAI, BattleKeeper.entity.battleAI})
end

-- 选择一个目标
function CharacterKeeper.SelectTarget(team, skill)
    local targetTeam = (team == Constants.team.up) and Constants.team.down or Constants.team.up
    local characters = self.characters[targetTeam]

    if #characters == 0 then
        return nil
    end

    return characters[1]
end
