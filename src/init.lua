export type Method = "GET" | "POST" | "PUT" | "DELETE"
export type MessageData = {
	channel: string,
	thread_ts: string?,

	text: string,
	attachments: string?,
	blocks: string?,

	username: string?,
	as_user: boolean?,
	icon_emoji: string?,
	icon_url: string?,
	link_names: boolean?,
	unfurl_links: boolean?,
	unfurl_media: boolean?,
	metadata: string?,
	mrkdwn: boolean?,
	parse: string?,
	reply_broadcast: boolean?,
}

export type ThreadData = {
	channel: string,
	ts: string,

	cursor: string?,
	include_all_metadata: boolean?,
	inclusive: boolean?,
	latest: string?,
	limit: number?,
	oldest: string?,
}

export type ChannelData = {
	channel: string,
	cursor: string?,
	inclusive: boolean?,
	latest: string?,
	limit: number?,
	oldest: string?,
}

local HttpUtils = require(script.HttpUtils)

local RbxSlack = {}
RbxSlack.__index = RbxSlack

function RbxSlack.new(AuthToken: string)
	local self = setmetatable({
		AuthToken = AuthToken,
	}, RbxSlack)
	self._className = "RbxSlack"
	return self
end

-- Generic function to support any Slack API call.
-- https://api.slack.com/methods
function RbxSlack:CallAPI(api: string, method: Method, data: {[any]: any}): (boolean, any)
	return HttpUtils.request(self.AuthToken, api, method, data)
end

-- Send a message to a Slack channel.
-- https://api.slack.com/methods/chat.postMessage
function RbxSlack:SendMessage(messageData: MessageData): (boolean, any)
	return self:CallAPI("chat.postMessage", "POST", messageData)
end

-- Retrieve messages from a channel
-- https://api.slack.com/methods/conversations.history
function RbxSlack:ReadChannel(channelData: ChannelData): (boolean, any)
	return self:CallAPI("conversations.history", "GET", channelData)
end

-- Retrieve a thread from a message
-- https://api.slack.com/methods/conversations.replies
function RbxSlack:GetThread(threadData: ThreadData): (boolean, any)
	return self:CallAPI("conversations.replies", "GET", threadData)
end

return RbxSlack
