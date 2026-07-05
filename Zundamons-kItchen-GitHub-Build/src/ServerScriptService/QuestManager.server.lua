-- [[Script] QuestManager (ref: RBX3396935863214D0B8C8C694DA2DBBB6B)]]
local RS      = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RE      = RS:WaitForChild("RemoteEvents")
local ev      = RE:FindFirstChild("UpdateQuests")
if not ev then ev=Instance.new("RemoteEvent"); ev.Name="UpdateQuests"; ev.Parent=RE end
local qcEv    = RE:FindFirstChild("QuestCompleted")
if not qcEv then qcEv=Instance.new("RemoteEvent"); qcEv.Name="QuestCompleted"; qcEv.Parent=RE end

local QUESTS = {
    { id="q_harvest", title="First Harvest",    emoji="🌿", reward=10,
      unlock_hint = "The Kitchen Court is now fully unlocked — craft away! 🍳",
      desc="Gather 5 materials",
      check=function(d)
          local t,SKIP=0,{Gold=true,current_gold=true,guests_served=true,zones_visited=true,active_companion=true}
          for k,v in pairs(d) do if not SKIP[k] and type(v)=="number" then t=t+v end end
          return t, 5
      end },
    { id="q_bake",    title="Baker's Debut",     emoji="🍞", reward=20,
      unlock_hint = "The Promenade market stalls now have new recipes available! 🌸",
      desc="Craft any food item",
      check=function(d)
          local t=0
          for _,f in ipairs({"Bread","Apple Pie","Zunda Bread","Zunda Mochi","Royal Stew"}) do
              t=t+(d[f] or 0) end return t, 1 end },
    { id="q_serve",   title="A Warm Welcome",    emoji="🧑‍🍳", reward=30,
      unlock_hint = "The Ancient Ruins to the northwest stirs with an ancient energy...",
      desc="Serve your first guest",
      check=function(d) return d.guests_served or 0, 1 end },
    { id="q_explore", title="Zunda Explorer",    emoji="🗺",  reward=50,
      unlock_hint = "All zones unlocked! A secret recipe awaits at the Hilltop Shrine~ ⛩",
      desc="Visit all 4 teleporter zones",
      check=function(d)
          local zones=d.zones_visited or {}; local c=0
          for _,id in ipairs({"village","kitchen","eastpeaks","mystic"}) do if zones[id] then c=c+1 end end
          return c, 4 end },
}

local rewarded = {}
local function eval(player)
    if not _G.data or not _G.data[player.Name] then return end
    local d = _G.data[player.Name]
    local prog = {}
    for _, q in ipairs(QUESTS) do
        local cur, goal = q.check(d)
        prog[q.id] = {current=cur, goal=goal, done=cur>=goal}
        if cur >= goal then
            rewarded[player.Name] = rewarded[player.Name] or {}
            if not rewarded[player.Name][q.id] then
                rewarded[player.Name][q.id] = true
                d.Gold = (d.Gold or 0) + q.reward
                -- Fire QuestCompleted with full quest data including unlock hint
                qcEv:FireClient(player, {
                    id          = q.id,
                    title       = q.emoji .. " " .. q.title,
                    reward      = q.reward,
                    unlock_hint = q.unlock_hint,
                })
                print("[QuestManager] Quest complete: " .. q.id .. " for " .. player.Name)
            end
        end
    end
    ev:FireClient(player, QUESTS, prog)
end

Players.PlayerAdded:Connect(function(p)
    rewarded[p.Name] = {}
    task.wait(7)
    while p and p.Parent do eval(p); task.wait(4) end
end)
for _, p in ipairs(Players:GetPlayers()) do
    rewarded[p.Name] = {}
    task.spawn(function()
        task.wait(3)
        while p and p.Parent do eval(p); task.wait(4) end
    end)
end

print("[QuestManager] Ready — fires QuestCompleted on milestone")
