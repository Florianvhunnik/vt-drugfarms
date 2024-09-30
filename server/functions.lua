-- Debug handler
DebugHandler = function(type, message)
    if not Config.debugMode then return end
    if type == 'info' then
        message = "^5[INFO]^7 " .. message
    elseif type == 'error' then
        message = "^1[ERROR]^7 " .. message
    elseif type == 'warning' then
        message = "^3[WARNING]^7 " .. message
    elseif type == 'success' then
        message = "^2[SUCCESS]^7 " .. message
    else
        return false
    end; print('^6[DEBUG]^7 ' .. message)
end