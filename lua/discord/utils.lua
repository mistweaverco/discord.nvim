local version = require("discord.version").version
local plugins = require("discord.filetypes.plugins")

local M = {}

function M.get_nvim_distro()
  local distro
  if M.module_exists("lazyvim") then
    distro = "LazyVim"
  elseif M.module_exists("astronvim") then
    distro = "AstroNvim"
  elseif M.module_exists("nvchad") then
    distro = "NvChad"
  elseif M.module_exists("lvim") then
    distro = "LunarVim"
  elseif M.module_exists("vapour") then
    distro = "VapourNvim"
  else
    distro = "Neovim"
  end

  if distro ~= "Neovim" and not M.has_asset("logos", distro) then
    return "Neovim"
  end

  return distro
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
  -- Require `://` so Windows drive letters like `C:` are not treated as protocols
  return string.match(file_path, "^(%a+)://")
end

---Map a URI protocol to a plugin asset name, if one exists
---@param protocol string|nil
---@return string|nil
function M.get_plugin_asset(protocol)
  if not protocol then
    return nil
  end
  local asset_name = plugins[protocol] or protocol
  if M.has_asset("plugins", asset_name) then
    return asset_name
  end
  return nil
end

function M.get_filetype()
  return vim.bo.filetype
end

---Get the root directory of the plugin
---@return string|nil
M.get_plugin_path = function(p)
  local source = debug.getinfo(1).source
  local dir_path = source:match("@(.*/)") or source:match("@(.*\\)")
  if not dir_path then
    return
  end
  if p then
    return vim.fs.normalize(vim.fs.joinpath(dir_path, "..", "..", p))
  end
  return vim.fs.normalize(vim.fs.joinpath(dir_path, "..", ".."))
end

---
---@param type string
---@param name string
---@return boolean
function M.has_asset(type, name)
  if not type or not name or name == "" then
    return false
  end
  local asset_name = string.format(vim.fs.joinpath("assets", "%s", "%s.png"), type, name)
  if vim.fn.filereadable(M.get_plugin_path(asset_name)) == 1 then
    return true
  else
    return false
  end
end

---Resolve an asset to a type/name pair that exists on disk
---@param type "icons"|"logos"|"plugins"
---@param name string|nil
---@param fallback string|nil
---@return string
---@return string
function M.resolve_asset(type, name, fallback)
  fallback = fallback or "text"
  if name and M.has_asset(type, name) then
    return type, name
  end
  if M.has_asset("icons", fallback) then
    return "icons", fallback
  end
  return "icons", "text"
end

---Get the URL for an asset hosted on GitHub
---@param type "icons"|"logos"|"plugins"
---@param asset_name string|nil
---@return string
function M.get_asset_url(type, asset_name)
  if not asset_name or asset_name == "" then
    type = "icons"
    asset_name = "text"
  end
  return string.format(
    "https://raw.githubusercontent.com/mistweaverco/discord.nvim/main/assets/%s/%s.png?v=" .. version,
    type,
    asset_name
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
