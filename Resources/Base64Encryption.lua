local Base64 = {}

local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function toBinary(num, bits)
	local bin = ""
	for i = bits - 1, 0, -1 do
		local power = 2 ^ i
		if num >= power then
			bin = bin .. "1"
			num = num - power
		else
			bin = bin .. "0"
		end
	end
	return bin
end

local function fromBinary(bin)
	return tonumber(bin, 2)
end

local function xorBinary(binData, binKey)
	local result = {}
	local keyLen = #binKey
	for i = 1, #binData do
		local b1 = tonumber(binData:sub(i, i))
		local b2 = tonumber(binKey:sub(((i - 1) % keyLen) + 1, ((i - 1) % keyLen) + 1))
		result[i] = (b1 ~= b2) and "1" or "0"
	end
	return table.concat(result)
end

local function stringToBinary(str)
	local bin = {}
	for i = 1, #str do
		table.insert(bin, toBinary(str:byte(i), 8))
	end
	return table.concat(bin)
end

local function binaryToString(bin)
	local result = {}
	for i = 1, #bin, 8 do
		local byte = bin:sub(i, i + 7)
		table.insert(result, string.char(fromBinary(byte)))
	end
	return table.concat(result)
end

-- Псевдонимы, как ты хочешь
function Base64.base64Encode(input, key)
	assert(type(input) == "string", "Input must be string")
	assert(type(key) == "string" and #key > 0, "Key must be non-empty string")

	local binInput = stringToBinary(input)
	local binKey = stringToBinary(key)
	local xorResult = xorBinary(binInput, binKey)

	local padLen = (6 - (#xorResult % 6)) % 6
	xorResult = xorResult .. string.rep("0", padLen)

	local encoded = {}
	for i = 1, #xorResult, 6 do
		local segment = xorResult:sub(i, i + 5)
		local index = fromBinary(segment)
		table.insert(encoded, base64Chars:sub(index + 1, index + 1))
	end

	if padLen == 2 then table.insert(encoded, "=")
	elseif padLen == 4 then table.insert(encoded, "==") end

	return table.concat(encoded)
end

function Base64.base64Decode(encoded, key)
	assert(type(encoded) == "string", "Encoded must be string")
	assert(type(key) == "string" and #key > 0, "Key must be non-empty string")

	local clean = encoded:gsub("=", "")
	local bitStream = {}

	for i = 1, #clean do
		local char = clean:sub(i, i)
		local index = base64Chars:find(char)
		assert(index, "Invalid Base64 character: " .. char)
		table.insert(bitStream, toBinary(index - 1, 6))
	end

	local allBits = table.concat(bitStream)
	local extraBits = #allBits % 8
	if extraBits > 0 then
		allBits = allBits:sub(1, #allBits - extraBits)
	end

	local binKey = stringToBinary(key)
	local decodedBin = xorBinary(allBits, binKey)
	return binaryToString(decodedBin)
end

return Base64
