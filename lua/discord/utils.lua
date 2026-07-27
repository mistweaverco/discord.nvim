local version = require("discord.version").version

local M = {}

function M.get_nvim_distro()
  if M.module_exists("lazyvim") then
    return "LazyVim"
  elseif M.module_exists("astronvim") then
    return "AstroNvim"
  elseif M.module_exists("nvchad") then
    return "NvChad"
  elseif M.module_exists("lvim") then
    return "LunarVim"
  elseif M.module_exists("vapour") then
    return "VapourNvim"
  else
    return "Neovim"
  end
end

function M.get_gui_info()
  local info = vim.api.nvim_get_chan_info(1).client
  if info.type == "ui" then
    if info.name == "nvim-tui" then
      return "Terminal"
    end
    return info.name
  end
  return nil
end

function M.module_exists(module)
  local present = pcall(require, module)

  if not present then
    return false
  end

  return true
end

function M.get_file_protocol()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    return nil
  end
  local protocol = string.match(file_path, "^(%a+):")
  return protocol
end

function M.get_filetype()
  return vim.bo.filetype
end

---
---@param type string
---@param name string
---@return boolean
function M.has_asset(type, name)
  local asset_name
  if type == "icons" then
    asset_name = string.format("assets/icons/%s.png", name)
  elseif type == "logos" then
    asset_name = string.format("assets/logos/%s.png", name)
  else
    return false
  end
  if vim.fn.filereadable(asset_name) == 1 then
    return true
  else
    return false
  end
end

function M.get_asset_url(asset_name)
  return string.format(
    "https://raw.githubusercontent.com/mistweaverco/discord.nvim/main/assets/icons/%s.png?v=" .. version,
    asset_name
  )
end

function M.get_logo_url(logo_name)
  return string.format(
    "https://raw.githubusercontent.com/mistweaverco/discord.nvim/main/assets/logos/%s.png?v=" .. version,
    logo_name
  )
end

-- To ensure consistent option values, coalesce true and false values to 1 and 0
function M.coalesce_option(value)
  if type(value) == "boolean" then
    return value and 1 or 0
  end

  return value
end

-- Set option using either vim global or setup table
function M.set_option(self, option, default, validate)
  default = M.coalesce_option(default)
  validate = validate == nil and true or validate

  local g_variable = string.format("discord_%s", option)

  self.options[option] = M.coalesce_option(self.options[option])

  if validate then
    -- Warn on any duplicate user-defined options
    M.check_dup_options(self, option)
  end

  self.options[option] = self.options[option] or vim.g[g_variable] or default
end

-- Check and warn for duplicate user-defined options
function M.check_dup_options(self, option)
  local g_variable = string.format("neocord_%s", option)

  if self.options[option] ~= nil and vim.g[g_variable] ~= nil then
    local warning_fmt = "Duplicate options: `g:%s` and setup option `%s`"
    local warning_msg = string.format(warning_fmt, g_variable, option)

    self.log:warn(warning_msg)
  end
end

return M
