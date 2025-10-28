local M = {}

-- Mapeia alguns filetypes para nomes de servidores Mason
local server_map = {
  lua = "lua_ls",
  python = "pyright",
  javascript = "tsserver",
  typescript = "tsserver",
  html = "html",
  css = "cssls",
  json = "jsonls",
  rust = "rust_analyzer",
  go = "gopls",

  -- Frameworks JS/TS
  javascriptreact = "tsserver",
  typescriptreact = "tsserver",
  vue = "volar",
  svelte = "svelte",
  tailwind = "tailwindcss",

  -- C, C++, C#
  c = "clangd",
  cpp = "clangd",
  cs = "csharp_ls", -- (ou "omnisharp")

  -- Outras linguagens comuns
  sh = "bashls",
  java = "jdtls",
  php = "intelephense",
  ruby = "solargraph",
  elixir = "elixirls",

  -- Arquivos de configuração e dados
  yaml = "yamlls",
  dockerfile = "dockerls",
  terraform = "terraformls",
  prisma = "prismals",
  markdown = "marksman",
}

-- Função que mostra uma janela flutuante fixa (fecha com <Esc>)
function M.show_popup(filetype, lsp_name)
  local buf = vim.api.nvim_create_buf(false, true)

  local msg = string.format(
    "⚠️  Nenhum LSP ativo para '%s'\nPressione 'i' para instalar %s via Mason",
    filetype,
    lsp_name or "um servidor compatível"
  )

  local lines = {}
  for line in msg:gmatch("[^\n]+") do
    table.insert(lines, " " .. line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = math.max(#msg + 8, 50)
  local win_height = #lines + 2
  local row = math.floor(height - win_height - 2)
  local col = math.floor(width - win_width - 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, "winhl", "Normal:NormalFloat,FloatBorder:Title")

  -- Fecha com <Esc>
  vim.keymap.set("n", "<Esc>", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true })

  -- Instala o LSP com 'i'
  vim.keymap.set("n", "i", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if lsp_name then
      vim.cmd("Mason")
      vim.defer_fn(function()
        vim.cmd("MasonInstall " .. lsp_name)
      end, 200)
      vim.notify("Instalando " .. lsp_name .. " via Mason...", vim.log.levels.INFO, { title = "LSP Installer" })
    else
      vim.cmd("Mason")
      vim.notify(
        "Abra o Mason e escolha manualmente um servidor para '" .. filetype .. "'",
        vim.log.levels.WARN,
        { title = "LSP não encontrado" }
      )
    end
  end, { buffer = buf, nowait = true })
end

-- Função principal (verifica LSP e chama o popup)
function M.lsp_compass()
  local filetype = vim.bo.filetype
  if filetype == "" then return end

  local buftype = vim.bo.buftype
  local name = vim.api.nvim_buf_get_name(0)
  if buftype ~= "" or name == "" then return end

  -- Verifica se há algum cliente LSP ativo
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    local lsp_name = server_map[filetype]
    M.show_popup(filetype, lsp_name)
  end
end

-- Configuração
function M.setup()
  vim.api.nvim_create_user_command("Compass", M.lsp_compass, {})

  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      local name = vim.api.nvim_buf_get_name(args.buf)

      -- Só mostra popup se for um arquivo real
      if buftype == "" and name ~= "" and filetype ~= "" then
        M.lsp_compass()
      end
    end,
  })
end

return M

