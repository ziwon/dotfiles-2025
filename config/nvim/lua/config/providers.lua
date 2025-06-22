-- Provider configuration for Neovim
local M = {}

function M.setup()
  -- Python provider setup with UV and mise integration
  local function setup_python_provider()
    -- First check for UV virtual environment in current directory or parent directories
    local function find_uv_venv()
      local current_dir = vim.fn.getcwd()
      local check_dir = current_dir
      
      -- Look for .venv in current directory and parent directories
      for _ = 1, 10 do -- Limit search depth
        local venv_path = check_dir .. "/.venv"
        local uv_lock = check_dir .. "/uv.lock"
        
        if vim.fn.isdirectory(venv_path) == 1 and vim.fn.filereadable(uv_lock) == 1 then
          local python_bin = venv_path .. "/bin/python"
          if vim.fn.executable(python_bin) == 1 then
            return python_bin
          end
        end
        
        local parent_dir = vim.fn.fnamemodify(check_dir, ":h")
        if parent_dir == check_dir then
          break -- Reached root directory
        end
        check_dir = parent_dir
      end
      
      return nil
    end
    
    -- Try UV virtual environment first
    local uv_python = find_uv_venv()
    if uv_python then
      vim.g.python3_host_prog = uv_python
      return true
    end
    
    -- Try to get Python from mise second
    local mise_python_cmd = "mise where python 2>/dev/null || echo ''"
    local mise_python_path = vim.fn.system(mise_python_cmd):gsub("%s+", "")
    
    if mise_python_path ~= "" and vim.fn.isdirectory(mise_python_path) == 1 then
      local python_bin = mise_python_path .. "/bin/python"
      if vim.fn.executable(python_bin) == 1 then
        vim.g.python3_host_prog = python_bin
        return true
      end
    end
    
    -- Fallback to system Python with pynvim
    local system_python = vim.fn.exepath("python3") or vim.fn.exepath("python")
    if system_python ~= "" then
      -- Check if pynvim is available
      local check_pynvim = vim.fn.system(system_python .. " -c 'import pynvim; print(pynvim.__version__)' 2>/dev/null")
      if vim.v.shell_error == 0 then
        vim.g.python3_host_prog = system_python
        return true
      end
    end
    
    return false
  end

  -- Setup Python provider
  if setup_python_provider() then
    -- Ensure Python provider is NOT disabled
    vim.g.loaded_python3_provider = nil  -- Remove any disable flag
  else
    vim.notify("Python provider setup failed. Install pynvim: pip install pynvim", vim.log.levels.WARN)
  end

  -- Node provider setup (keep disabled unless needed)
  local mise_node_cmd = "mise where node 2>/dev/null || echo ''"
  local mise_node_path = vim.fn.system(mise_node_cmd):gsub("%s+", "")
  if mise_node_path ~= "" and vim.fn.isdirectory(mise_node_path) == 1 then
    local node_bin = mise_node_path .. "/bin/node"
    if vim.fn.executable(node_bin) == 1 then
      vim.g.node_host_prog = node_bin
    end
  end

  -- Clipboard setup for WSL2
  if vim.fn.has("wsl") == 1 then
    -- Try win32yank first, then wl-clipboard
    if vim.fn.executable("win32yank.exe") == 1 then
      vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
          ["+"] = "win32yank.exe -i --crlf",
          ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
          ["+"] = "win32yank.exe -o --lf",
          ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
      }
    elseif vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
      vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
          ["+"] = "wl-copy",
          ["*"] = "wl-copy --primary",
        },
        paste = {
          ["+"] = "wl-paste",
          ["*"] = "wl-paste --primary",
        },
        cache_enabled = 0,
      }
    end
  end
end

return M
