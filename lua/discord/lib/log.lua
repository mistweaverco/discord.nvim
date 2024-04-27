local M = {}

M.codes = {}
M.levels = {
  { "debug", "Comment" },
  { "info", "None" },
  { "warn", "WarningMsg" },
  { "error", "ErrorMsg" },
}

function M:init(options)
  self.level = options.level
  return self
end

-- Initialize logger with log functions for each level
for i = 1, #M.levels do
  local level, hl = unpack(M.levels[i])

  M.codes[level] = i

  M[level] = function(self, message)
    -- Skip if log level is not set or the log is below the configured or default level
    if not self.level or self.codes[level] < self.codes[self.level] or type(message) ~= "string" then
      return
    end

    vim.schedule(function()
      local escaped_message = vim.fn.escape(message, '"'):gsub("\n", "\\n")

      vim.cmd(string.format("echohl %s", hl))
      vim.cmd(string.format([[echom "[%s] %s"]], "discord", escaped_message))
      vim.cmd("echohl NONE")
    end)
  end
end

return M
