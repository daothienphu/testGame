require "script_common.main"
if World.isClient then
require "script_client.main"
else
require "script_server.main"
end