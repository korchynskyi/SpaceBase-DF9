local m = {}

local DFUtil = require("DFCommon.Util")
local UIElement = require('UI.UIElement')
local DFInput = require('DFCommon.Input')
local SoundManager = require('SoundManager')
local Gui = require("UI.Gui")

local sUILayoutFileName = 'UILayouts/BeaconMenuEntryLayout'

function m.create()
    local Ob = DFUtil.createSubclass(UIElement.create())
	local name
	-- local disabled = false
	
	function Ob:init()
        self:setRenderLayer('UIScrollLayerLeft')

        Ob.Parent.init(self)
        self:processUIInfo(sUILayoutFileName)
		self.rNameLabel = self:getTemplateElement('NameLabel')
		self.rHotKey = self:getTemplateElement('Hotkey')
		self.rNameButton = self:getTemplateElement('NameButton')
		self.rNameButton:addPressedCallback(self.onButtonClicked, self)
		
		self:_calcDimsFromElements()
	end
	
	function Ob:setName(_name, _hotkey, callback)
		name = _name
		self.rNameLabel:setString(name)
		self.rHotKey:setString(_hotkey)
		self.callback = callback
	end
	
	function Ob:setSelected(isSelected)
		self.rNameButton:setSelected(isSelected)
	end
	
	function Ob:onButtonClicked(rButton, eventType)
		if eventType == DFInput.TOUCH_UP and not disabled then
			self:callback(self, name)
			SoundManager.playSfx('degauss')
		end
	end
	
	function Ob:hide(bKeepAlive)
		disabled = true
		if self.rNameLabel then
			self.rNameLabel:setVisible(false)
		end
		if self.rNameButton then
			self.rNameButton:setVisible(false)
		end
		if self.rHotKey then
			self.rHotKey:setVisible(false)
		end
        Ob.Parent.hide(self, bKeepAlive)
    end
	
	function Ob:show(basePri)
        local nPri = Ob.Parent.show(self, basePri)
        disabled = false
		if self.rNameLabel then
			self.rNameLabel:setVisible(true)
		end
		if self.rNameButton then
			self.rNameButton:setVisible(true)
		end
		if self.rHotKey then
			self.rHotKey:setVisible(true)
		end
        return nPri
    end
	
	return Ob
end

function m.new(...)
    local Ob = m.create()
    Ob:init(...)

    return Ob
end

return m