--[[
    rblxmvm
    something#7597
ideas:

campaths
    3 passes, regular, depth, greenscreen
    camdata exporting into AE
        ae script to import camdata

widget layout:
dollycam:
    create point

]]--

-- widget
local widgetInfo  = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float,
	false,
	false,
	200,
	200,
	150,
	150)
local widget = plugin:CreateDockWidgetPluginGui("rblxmvm", widgetInfo)
widget.Title = "rblxmvm - something/xalon"

-- dependencies
local moduledir = script.Parent.modules

-- initalizing widget
local wdg = require(moduledir.widgets.initalize)
wdg:GenerateWidget(widget)

require(moduledir.widgets.require)(plugin)

local dep = require(script.Parent.dependencies)

-- toolbar
local toolbar = plugin:CreateToolbar("rblxmvm")

-- buttons
local b_toggle = toolbar:CreateButton("Toggle","Toggle widget","")

-- local variables


-- local functions

local function createAction(id, title, desc, icon, action, bindable)
    return plugin:CreatePluginAction(id, title, desc .. " - rblxmvm", icon, bindable).Triggered:Connect(action)
end

b_toggle.Click:Connect(function() widget.Enabled = not widget.Enabled end)
createAction("toggleWidget", "Toggle Widget", "Toggles widget", "", function() widget.Enabled = not widget.Enabled end)


dep.dollycam.resetTimescale()



-- DOLLYCAM

dep.RunService.Heartbeat:Connect(dep.dollycam.playback)
wdg["pathDropdown"]:GetButton().MouseButton1Click:Connect(dep.dollycam.reloadDropdown)




-- creating points
local function createPoint()
    if not dep.dollycam.playing then
        dep.dollycam.createPoint(dep.setRoll.angle, workspace.CurrentCamera.FieldOfView)
    end
end
wdg["createPoint"].MouseButton1Down:Connect(createPoint)
createAction("createPoint", "Create Point", "Creates a campath point", "", createPoint)


-- running path
local function runPath()
    if not dep.dollycam.playing then dep.dollycam.runPath(dep.dollycam.timescale) end
end
wdg["runPath"].MouseButton1Down:Connect(runPath)
createAction("runPath", "Play Path", "Plays selected path", "", runPath)


-- stop playback
local function stopPath()
    if dep.dollycam.playing then dep.dollycam.stop() end
end
wdg["stopPath"].MouseButton1Down:Connect(stopPath)
createAction("stopPath", "Stop Playback", "Stops playback", "", stopPath)


-- editing roll
local function editRoll()
    if not dep.dollycam.playing then dep.setRoll.toggleRollGui() end
end
wdg["editRoll"].MouseButton1Down:Connect(editRoll)
createAction("editRoll", "Edit Roll", "Toggles roll GUI", "", editRoll)


wdg["timescaleInput"]:SetValueChangedFunction(function(newts)
    if tonumber(newts) then
        if not dep.dollycam.playing then
            dep.dollycam.timescale = newts
        else
            wdg["timescaleInput"]:SetValue(dep.dollycam.timescale)
        end
    end
end)

wdg["fovInputSlider"]:SetValueChangedFunction(function(newfov)
    if not dep.dollycam.playing then 
        workspace.CurrentCamera.FieldOfView = newfov
        wdg["fovInput"]:SetValue(newfov)
    else
        wdg["fovInputSlider"]:SetValue(workspace.CurrentCamera.FieldOfView)
    end
end)

wdg["fovInput"]:SetValueChangedFunction(function(newfov)
    if tonumber(newfov) then
        if not dep.dollycam.playing then 
            workspace.CurrentCamera.FieldOfView = newfov
            wdg["fovInputSlider"]:SetValue(newfov)
        else
            wdg["fovInput"]:SetValue(workspace.CurrentCamera.FieldOfView)
        end
    end
end)

wdg["rollInput"]:SetValueChangedFunction(function(newroll)
    if tonumber(newroll) then
        if not dep.dollycam.playing and not dep.setRoll.roll_active then
            dep.setRoll.angle = newroll
        else
            wdg["rollInput"]:SetValue(dep.setRoll.angle)
        end
    end
end)

wdg["pathDropdown"]:SetValueChangedFunction(function(newpath)
    if not dep.dollycam.playing then
        wdg["pathNameInput"]:SetValue(newpath.Name)
        dep.dollycam.renderPath()
    end
end)

wdg["interpDropdown"]:SetValueChangedFunction(function(newinterp)
    if not dep.dollycam.playing then
        dep.dollycam.interpMethod = dep.interp[newinterp]
        dep.dollycam.renderPath()
    end
end)