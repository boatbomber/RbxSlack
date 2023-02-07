# RbxSlack

RbxSlack is a module for interacting with Slack APIs from Roblox. It provides a generic `CallAPI` method that supports all the Slack web methods [here](https://api.slack.com/methods), as well as some functions for the common methods to make usage easier, such as `SendMessage`.

## Example Usage

```Lua
local Packages = game:GetService("ServerStorage"):WaitForChild("Packages")
local RbxSlack = require(Packages:WaitForChild("RbxSlack"))

local MyBot = RbxSlack.new("MyBotAuthToken")

RbxSlack:SendMessage({
	channel = "channelIdHere",
	text = "Hello world!",
})
```

## API Reference

```Lua
function RbxSlack.new(AuthToken: string): RbxSlack
```
Creates an RbxSlack object using the given AuthToken

```Lua
function RbxSlack:CallAPI(api: string, method: Method, data: {[any]: any}): (boolean, any)
```
Generic function to interface with any Slack web API. For all available methods and their data parameters, see here: https://api.slack.com/methods.

```Lua
function RbxSlack:SendMessage(messageData: MessageData): (boolean, any)
```
Sends a message to a Slack channel or thread. Uses https://api.slack.com/methods/chat.postMessage.

```Lua
function RbxSlack:ReadChannel(channelData: ChannelData): (boolean, any)
```
Retrieves messages from a channel. Uses https://api.slack.com/methods/conversations.history.

```Lua
function RbxSlack:GetThread(threadData: ThreadData): (boolean, any)
```
Retrieves a thread from under a given message. Uses https://api.slack.com/methods/conversations.replies.
