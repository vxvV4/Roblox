-- ============================================
-- LUA SYNTAX DETECTOR MODULE
-- Detects and validates Lua code syntax
-- Created by Aux Devs This still on beta will be replaced with better Detections MWEHEHEHEHEHEHE
-- ============================================

local SyntaxDetector = {}

-- ============================================
-- LUA KEYWORDS
-- ============================================
local LUA_KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function",
    "if", "in", "local", "nil", "not", "or", "repeat", "return", "then",
    "true", "until", "while", "goto", "continue"
}

-- ============================================
-- LUA OPERATORS
-- ============================================
local LUA_OPERATORS = {
    "+", "-", "*", "/", "%", "^", "#",
    "==", "~=", "<=", ">=", "<", ">", "=",
    "(", ")", "{", "}", "[", "]", ";",
    ":", ",", ".", "..", "..."
}

-- ============================================
-- CHECK IF STRING IS A KEYWORD
-- ============================================
function SyntaxDetector:isKeyword(word)
    for _, keyword in ipairs(LUA_KEYWORDS) do
        if word == keyword then
            return true
        end
    end
    return false
end

-- ============================================
-- CHECK IF CHARACTER IS AN OPERATOR
-- ============================================
function SyntaxDetector:isOperator(char)
    for _, op in ipairs(LUA_OPERATORS) do
        if char == op or char:sub(1, 1) == op then
            return true
        end
    end
    return false
end

-- ============================================
-- DETECT IF CODE IS VALID LUA
-- ============================================
function SyntaxDetector:isValidLua(code)
    if type(code) ~= "string" then
        return false, "Input must be a string"
    end
    
    if code == "" or code:match("^%s*$") then
        return false, "Code is empty"
    end
    
    -- Try to load the code (compile it)
    local func, err = loadstring(code)
    
    if func then
        return true, "Syntax is valid"
    else
        return false, err
    end
end

-- ============================================
-- DETECT LUA SYNTAX ELEMENTS
-- ============================================
function SyntaxDetector:detectSyntax(code)
    local results = {
        hasKeywords = false,
        keywords = {},
        hasOperators = false,
        operators = {},
        hasFunctions = false,
        functions = {},
        hasVariables = false,
        variables = {},
        hasStrings = false,
        strings = {},
        hasComments = false,
        comments = {},
        lineCount = 0,
        characterCount = 0
    }
    
    if type(code) ~= "string" then
        return results
    end
    
    results.characterCount = #code
    results.lineCount = select(2, code:gsub('\n', '\n')) + 1
    
    -- Detect Keywords
    for _, keyword in ipairs(LUA_KEYWORDS) do
        if code:match("%f[%w_]" .. keyword .. "%f[^%w_]") then
            results.hasKeywords = true
            table.insert(results.keywords, keyword)
        end
    end
    
    -- Detect Functions
    for funcName in code:gmatch("function%s+([%w_]+)") do
        results.hasFunctions = true
        table.insert(results.functions, funcName)
    end
    
    -- Detect local functions
    for funcName in code:gmatch("local%s+function%s+([%w_]+)") do
        if not table.find(results.functions, funcName) then
            table.insert(results.functions, funcName)
        end
    end
    
    -- Detect Variables (local declarations)
    for varName in code:gmatch("local%s+([%w_]+)") do
        if not code:match("local%s+function%s+" .. varName) then
            results.hasVariables = true
            if not table.find(results.variables, varName) then
                table.insert(results.variables, varName)
            end
        end
    end
    
    -- Detect Strings
    for str in code:gmatch('"([^"]*)"') do
        results.hasStrings = true
        table.insert(results.strings, str)
    end
    
    for str in code:gmatch("'([^']*)'") do
        results.hasStrings = true
        table.insert(results.strings, str)
    end
    
    -- Detect Comments
    for comment in code:gmatch("%-%-([^\n]*)") do
        results.hasComments = true
        table.insert(results.comments, comment)
    end
    
    -- Detect Multi-line comments
    for comment in code:gmatch("%-%-%[%[(.-)%]%]") do
        results.hasComments = true
        table.insert(results.comments, comment)
    end
    
    -- Detect Operators
    for _, op in ipairs(LUA_OPERATORS) do
        if code:find(op, 1, true) then
            results.hasOperators = true
            if not table.find(results.operators, op) then
                table.insert(results.operators, op)
            end
        end
    end
    
    return results
end

-- ============================================
-- COMPREHENSIVE SYNTAX CHECK
-- ============================================
function SyntaxDetector:analyzeSyntax(code)
    local isValid, message = self:isValidLua(code)
    local syntaxDetails = self:detectSyntax(code)
    
    return {
        valid = isValid,
        message = message,
        details = syntaxDetails,
        summary = {
            totalLines = syntaxDetails.lineCount,
            totalCharacters = syntaxDetails.characterCount,
            keywordCount = #syntaxDetails.keywords,
            functionCount = #syntaxDetails.functions,
            variableCount = #syntaxDetails.variables,
            stringCount = #syntaxDetails.strings,
            commentCount = #syntaxDetails.comments
        }
    }
end

-- ============================================
-- CHECK IF CODE CONTAINS DANGEROUS PATTERNS
-- ============================================
function SyntaxDetector:detectDangerousCode(code)
    local dangerous = {
        hasDangerousCode = false,
        patterns = {}
    }
    
    local dangerousPatterns = {
        {pattern = "loadstring", reason = "Remote code execution"},
        {pattern = "require%(game%.HttpGet", reason = "Loading external scripts"},
        {pattern = "game:HttpGet", reason = "HTTP requests"},
        {pattern = "getfenv", reason = "Environment manipulation"},
        {pattern = "setfenv", reason = "Environment manipulation"},
        {pattern = "debug%.getupvalue", reason = "Debug library usage"},
        {pattern = "debug%.setupvalue", reason = "Debug library usage"},
        {pattern = "hookfunction", reason = "Function hooking"},
        {pattern = "hookmetamethod", reason = "Metamethod hooking"}
    }
    
    for _, check in ipairs(dangerousPatterns) do
        if code:find(check.pattern, 1, true) then
            dangerous.hasDangerousCode = true
            table.insert(dangerous.patterns, {
                pattern = check.pattern,
                reason = check.reason
            })
        end
    end
    
    return dangerous
end

-- ============================================
-- PRETTY PRINT ANALYSIS
-- ============================================
function SyntaxDetector:printAnalysis(code)
    local analysis = self:analyzeSyntax(code)
    local dangerous = self:detectDangerousCode(code)
    
    print("\n========================================")
    print("     LUA SYNTAX ANALYSIS REPORT")
    print("========================================\n")
    
    print("📊 VALIDITY CHECK:")
    print("  Status: " .. (analysis.valid and "✅ VALID" or "❌ INVALID"))
    print("  Message: " .. analysis.message .. "\n")
    
    print("📈 STATISTICS:")
    print("  Lines: " .. analysis.summary.totalLines)
    print("  Characters: " .. analysis.summary.totalCharacters)
    print("  Keywords: " .. analysis.summary.keywordCount)
    print("  Functions: " .. analysis.summary.functionCount)
    print("  Variables: " .. analysis.summary.variableCount)
    print("  Strings: " .. analysis.summary.stringCount)
    print("  Comments: " .. analysis.summary.commentCount .. "\n")
    
    if #analysis.details.keywords > 0 then
        print("🔑 KEYWORDS FOUND:")
        print("  " .. table.concat(analysis.details.keywords, ", ") .. "\n")
    end
    
    if #analysis.details.functions > 0 then
        print("⚙️ FUNCTIONS FOUND:")
        for _, func in ipairs(analysis.details.functions) do
            print("  - " .. func)
        end
        print("")
    end
    
    if #analysis.details.variables > 0 then
        print("📦 VARIABLES FOUND:")
        for _, var in ipairs(analysis.details.variables) do
            print("  - " .. var)
        end
        print("")
    end
    
    if dangerous.hasDangerousCode then
        print("⚠️ DANGEROUS PATTERNS DETECTED:")
        for _, pattern in ipairs(dangerous.patterns) do
            print("  ⚠️ " .. pattern.pattern .. " - " .. pattern.reason)
        end
        print("")
    else
        print("✅ NO DANGEROUS PATTERNS DETECTED\n")
    end
    
    print("========================================\n")
    
    return analysis, dangerous
end

-- ============================================
-- USAGE EXAMPLES
-- ============================================

--[[ EXAMPLE 1: Check if code is valid
local code = [[
    local function test()
        print("Hello World")
    end
]]

local isValid, message = SyntaxDetector:isValidLua(code)
print("Valid:", isValid, "Message:", message)
]]--

--[[ EXAMPLE 2: Analyze syntax
local code = [[
    local x = 10
    local function add(a, b)
        return a + b
    end
    print(add(x, 5))
]]

local analysis = SyntaxDetector:analyzeSyntax(code)
print("Valid:", analysis.valid)
print("Functions found:", #analysis.details.functions)
]]
SyntaxDetector:printAnalysis(code)
]]

return SyntaxDetector
