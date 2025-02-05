local M = {}
function M.getVenvSuffix()
  if vim.loop.os_uname().sysname == 'Windows_NT' then
    return 'Scripts/python.exe'
  else
    return 'bin/python'
  end
end

function M.getVenvFromJson(jsonfile)
  if not vim.fn.filereadable(jsonfile) then
    return nil
  end
  local f = io.open(jsonfile, 'r')
  if not f then
    return nil
  end
  local data = f:read('*a')
  f:close()
  if data then
    local jdata = vim.json.decode(data)
    if jdata['venvPath'] ~= nil and jdata['venv'] ~= nil then
      return jdata['venvPath'] .. '/' .. jdata['venv']
    end
  end
  return nil
end

function M.getPythonEnv()
  local venv = os.getenv('VIRTUAL_ENV')
  if venv ~= nil then
    return string.format('%s/%s', venv, M.getVenvSuffix())
  end
  local conda = os.getenv('CONDA_PREFIX')
  if conda ~= nil then
    return string.format('%s/%s', conda, M.getVenvSuffix())
  end

  local cwd = vim.fn.getcwd()

  local jsonVenv = M.getVenvFromJson(cwd .. '/pyrightconfig.json')
  if jsonVenv ~= nil then
    return jsonVenv .. '/' .. M.getVenvSuffix()
  end

  if vim.fn.executable(cwd .. '/venv/' .. M.getVenvSuffix()) == 1 then
    return cwd .. '/venv/' .. M.getVenvSuffix()
  elseif vim.fn.executable(cwd .. '/.venv/' .. M.getVenvSuffix()) == 1 then
    return cwd .. '/.venv/' .. M.getVenvSuffix()
  else
    if vim.loop.os_uname().sysname == 'Linux' then
      return '/home/yi/miniconda3/bin/python'
    elseif vim.loop.os_uname().sysname == 'Windows_NT' then
      return os.getenv('SCOOP') .. '/apps/python/current/python.exe'
    end
  end
end

return M

