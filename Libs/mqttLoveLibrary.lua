local mqtt = require('./Libs/mqtt')

local port = 1883
local mqttClient
local defaultTopic

MqttLoveLibrary = {}


--[[
	function to start the mqttClient. It connects to the broker and subscribes to a predefined channel.
	id: unique id for the user
	callbackFunction: optional, function to be called when the application receives a message. 
					  If nil, function stored  in 'messageReceived' will be called
]]
function MqttLoveLibrary.start(host, id, listchannel, callbackFunction)
  local callback = callbackFunction
  defaultTopic = string.format('%s node', id)
  listchannel = listchannel or string.format('%slove', id)
  mqttClient = mqtt.client.create(host, port, function(topic , message)
		print(string.format('received message %s from topic %s', message, topic))
		callback(message)
	end)
  local connectErrorMessage = mqttClient:connect(string.format('%slove', id))
  if(connectErrorMessage) then
    print(string.format('Error connecting! %s', connectErrorMessage))
  end
  mqttClient:subscribe({listchannel})
  print('connecting to %s', listchannel)
end

--[[
	function to send a message
	message: message to be sent
	topic: optional, channel to send the message. If nil the message will be sent to a default channel
]]
function MqttLoveLibrary.sendMessage(message, topic)
  topic = topic or defaultTopic
  mqttClient:publish(topic, message)
  print(string.format('Sending message %s to topic %s', message, topic))
end

--[[
	function to check if messages were received in the subscribed channels
]]
function MqttLoveLibrary.checkMessages()
	local errorMessage = mqttClient:handler()
	if(errorMessage) then
		print(string.format('Error checking for messages! %s', errorMessage))
	end
end

return(MqttLoveLibrary)
