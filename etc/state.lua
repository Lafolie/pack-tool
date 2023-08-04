local State = class {}

function State:update(ioChannel) end
function State:enter(ioChannel) end
function State:leave(ioChannel) end
function State:getStatusString() return "Status" end
function State:getHelpString() return "Help" end
function State:mouseMoved(x, y) end
function State:mousePressed(btn, x, y) end
function State:mouseReleased(btn, x, y) end
function State:keyPressed(key, ctrl) end
function State:draw() end

return State