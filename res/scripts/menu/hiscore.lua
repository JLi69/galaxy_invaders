-- high score keeps track of the following data
-- score, wave, date

local hiscore = {}

hiscore.MAX_SCORE_COUNT = 5

-- Utility function to check if file exists
function hiscore.canOpenFile(path)
	file = io.open(path)
	if file then
		file:close() -- can open file, close and return true
		return true
	end
	-- File does not exist
	return false
end

-- Read highscores from the file
function hiscore.readscores(hiscoreFilePath)
	hiscore.hiscores = {} -- initialize the table of highscores to be an empty array
	if hiscore.canOpenFile(hiscoreFilePath) then
		local lineNum = 0 -- Keep track of the number of lines in the high score file
		for line in io.lines(hiscoreFilePath) do -- Each line in the file is assumed to be a high score entry
			lineNum = lineNum + 1
		
			-- read too many entries, ignore all the rest
			if lineNum > hiscore.MAX_SCORE_COUNT then
				return
			end

			local hiscoreValue = {}		
			local fields = { "score", "wave", "date" } -- Three data points tracked for the high score:
													   -- score, high score of player
													   -- wave, the wave that they died on
													   -- date, the date at which they acheived this high score
			hiscoreValue.score = 0
			hiscoreValue.wave = 0
			hiscoreValue.date = ""

			local ind = 1 -- This keeps track of the name of the current field that we are reading to
			
			-- Assume data is formatted as following:
			-- [score] [wave] [date]
			for i = 1, #line do	
				local ch = string.sub(line, i, i) -- Get a single character
				
				-- If it is a valid digit,
				-- and we are on index 1 or 2 (score/wave)
				-- add digit to that value
				if ind <= 2 and tonumber(ch) ~= nil then 
					hiscoreValue[fields[ind]] = hiscoreValue[fields[ind]] * 10
					hiscoreValue[fields[ind]] = hiscoreValue[fields[ind]] + tonumber(ch)
				-- On date, just append the character to the string
				elseif ind == 3 then
					hiscoreValue[fields[ind]] = hiscoreValue[fields[ind]] .. ch
				else
					-- Hit non digit character for score/wave (assume it is a space) (index 1 or 2)
					-- Increment ind by 1 and read into the next field
					ind = ind + 1
				end
			end
			
			-- Append this high score to the list
			hiscore.hiscores[#hiscore.hiscores + 1] = hiscoreValue	
		end
	end
end

-- Checks if the score is within the top 10 scores
-- returns true if it is the case, false otherwise
-- pass in a table with the fields score, wave, and date
-- (NOTE: the table actually only needs a field of score
-- but it should have a field of wave and date if everything
-- worked properly)
function hiscore.checkForNewHigh(score)
	-- If hiscore.hiscores is nil, then it is an
	-- empty array which means we definitely have a new
	-- high score
	if hiscore.hiscores ~= nil then
		-- If we have less than the number of high scores that
		-- we want to keep track of that means that we can juts add
		-- it to the list
		if #hiscore.hiscores < hiscore.MAX_SCORE_COUNT then
			return true
		end

		-- Find minimum high score that we are keeping track of
		-- so that we can determine if the score is large enough
		local min = hiscore.hiscores[1].score
		for i = 1, #hiscore.hiscores do
			if min > hiscore.hiscores[i].score then
				min = hiscore.hiscores[i].score
			end
		end
		
		-- Greater than lowest score, we can replace lowest score
		-- and put it in
		if score.score >= min then
			return true
		else
			-- Not bigger, cannot put score in
			return false
		end
	end
	-- Empty high score array, always true
	return true
end

function hiscore.tryToAddHigh(score)
	if hiscore.hiscores == nil then
		-- Empty array, insert score
		hiscore.hiscores = { score }
	elseif #hiscore.hiscores < hiscore.MAX_SCORE_COUNT then
		-- High score count is less than the number of highscores
		-- we want to keep track of, we can juts append it to the list
		hiscore.hiscores[1 + #hiscore.hiscores] = score
	elseif hiscore.checkForNewHigh(score) then
		-- Find the minimum value and get its index
		-- so that we can determine which score to replace
		local minInd = 1
		local minVal = hiscore.hiscores[1].score
		for i = 1, #hiscore.hiscores do
			if minVal > hiscore.hiscores[i].score then
				minVal = hiscore.hiscores[i].score
				minInd = i
			end
		end
		
		-- Replace lowest score with new score
		hiscore.hiscores[minInd] = score
	end
end

-- Write the high scores to a file so that they can be saved
function hiscore.saveHighScores(path)
	local hiscoreFile = io.open(path, "w")

	if hiscoreFile and hiscore.hiscores ~= nil then
		for i = 1, #hiscore.hiscores do
			local score = hiscore.hiscores[i]
			hiscoreFile:write(tostring(score.score) .. 
							  " " .. tostring(score.wave) ..
							  " " .. score.date .. "\n") 
		end

		hiscoreFile:close()
	end
end

-- Put scores in a sorted order
function hiscore.inOrder()
	-- Perform insertion sort on the list
	-- NOTE: while insertion sort is not the fastest algorithm,
	-- we are likely working with very small data sets and the 
	-- list is very likely to already be sorted which means
	-- that insertion sort is a simple and still effective algorithm
	-- for what we are doing
	for i = 2, #hiscore.hiscores do
		-- iterate through list backward
		local ind = i	
		local score = hiscore.hiscores[i].score
		while ind - 1 >= 1 and hiscore.hiscores[ind - 1].score < score do
			-- swap
			local temp = hiscore.hiscores[ind]
			hiscore.hiscores[ind] = hiscore.hiscores[ind - 1]
			hiscore.hiscores[ind - 1] = temp
			
			-- decrement ind
			ind = ind - 1;	
		end
	end
end

return hiscore
