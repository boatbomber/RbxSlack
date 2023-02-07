local HttpService = game:GetService("HttpService")

local HttpUtils = {}

--[[
	Sanitize a string for use in a URL query string.
]]
function HttpUtils.sanitize(str: string?): string
	if str == nil then
		return ""
	end
	local sanitized = string.gsub(string.gsub(string.gsub(str :: string,
		"\n", "\r\n"), -- Normalize newlines
		"([^%w _%%%-%.~])", function(c) -- Escape unsafe characters
			return string.format("%%%02X", string.byte(c))
		end),
		" ", "+" -- Escape spaces
	)
	return sanitized
end

--[[
	Encode a table of key-value pairs into a URL query string.
]]
function HttpUtils.encode(data: {[any]: any}): string
	local stringData = {}

	for key, value in pairs(data) do
		table.insert(stringData, tostring(key).."=".. HttpUtils.sanitize(tostring(value)))
	end

	return table.concat(stringData, "&")
end

--[[
	Make an HTTP request to the Slack API.
]]
function HttpUtils.request(auth: string, api: string, method: string, data: {any: any}): (boolean, any)
	local payload = {
		Method = method,
		Headers = {
			["Content-type"] = "application/x-www-form-urlencoded",
			["Authorization"] = auth,
		},
		Url = "https://slack.com/api/" .. api .. "?" .. HttpUtils.encode(data),
	}

	local requestSuccess, requestResponse = pcall(HttpService.RequestAsync, HttpService, payload)
	if not requestSuccess then
		return false, requestResponse
	end

	if not requestResponse.Success then
		return false, "HTTP " .. requestResponse.StatusCode .. ": " .. requestResponse.StatusMessage
	end

	local decodeSuccess, decodeResponse = pcall(HttpService.JSONDecode, HttpService, requestResponse.Body)
	if not decodeSuccess then
		return false, decodeResponse
	end

	if not decodeResponse.ok then
		return false, decodeResponse.error
	end

	return true, decodeResponse
end

return HttpUtils
