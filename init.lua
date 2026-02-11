-- ============================================================================
--   NERV TACTICAL CONSOLE // MAGI-01 SYSTEM
-- ============================================================================

-- 1. BOOTSTRAP LAZY
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

-- 2. PLUGINS
require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "rust_analyzer" },
        handlers = {
          function(server_name)
            local border = "single"
            require("lspconfig")[server_name].setup({
              handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = border }),
              }
            })
          end,
        }
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        window = {
          completion = cmp.config.window.bordered({ border = "single" }),
          documentation = cmp.config.window.bordered({ border = "single" }),
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' } })
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
require("ibl").setup({
      indent = { 
        char = "▏",
        highlight = { "IblIndent" }
      },
      scope = { 
        enabled = false,
        show_start = true,
        show_end = true,
        char = "▎",  -- THICKER CHARACTER for scope
        highlight = { "IblScope" }
      }
    })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '▎' },
        },
        current_line_blame = true,
        current_line_blame_opts = { delay = 300 },
      })
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00FF00" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#FFA500" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#FF0000" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = {
            normal = {
              a = { fg = "#000000", bg = "#FFA500", gui = "bold" },
              b = { fg = "#00FF00", bg = "#1A1A1A" },
              c = { fg = "#FFFFFF", bg = "#000000" },
            },
          },
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'filename'},
          lualine_c = {''},
          lualine_x = {'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        win = {
          border = "single",
        },
      })
      vim.api.nvim_set_hl(0, "WhichKeyFloat", { fg = "#FFFFFF", bg = "#000000" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#FFA500", bg = "#000000" })
    end,
  },
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
      vim.keymap.set('n', '<leader>t', ':Twilight<CR>', { desc = "Toggle focus mode" })
      
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("Twilight")
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = "Find files" })
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = "Search text" })
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = "Find buffers" })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("spectre").setup()
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
      vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
    end,
  },
  {
  "LuxVim/nvim-luxmotion",
  config = function()
    require("luxmotion").setup({
      fps = 60,
      duration = 300,
      
      -- Correct format - these are tables with enable option
      scroll = {
        enable = true,
      },
      cursor = {
        enable = true,
      },
      horizontal = {
        enable = true,
      },
    })
  end,
  },
})

-- 3. CORE SETTINGS
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.signcolumn = "number"
vim.opt.guicursor = "n-v-c:block,i:block"
vim.opt.cursorline = true

-- KEYBINDS
vim.keymap.set('n', '<C-a>', 'ggVG')

-- 4. THE NERV THEME
local function apply_nerv_theme()
    local orange = "#FFA500"
    local green  = "#00FF00"
    local purple = "#BF00FF"
    local black  = "#000000"
    local white  = "#FFFFFF"

    -- Global Background
    vim.api.nvim_set_hl(0, "Normal", { fg = white, bg = black })
    
    -- Command Line
    vim.api.nvim_set_hl(0, "MsgArea", { fg = orange, bg = black })
    vim.api.nvim_set_hl(0, "WildMenu", { fg = black, bg = orange, bold = true })
    vim.api.nvim_set_hl(0, "ModeMsg", { fg = orange, bold = true })
    
    -- Selection
    vim.api.nvim_set_hl(0, "Visual", { fg = black, bg = orange, bold = true })

    -- Syntax
    vim.api.nvim_set_hl(0, "Keyword", { fg = green, bold = true })
    vim.api.nvim_set_hl(0, "Function", { fg = green, bold = true })
    vim.api.nvim_set_hl(0, "String", { fg = purple })
    vim.api.nvim_set_hl(0, "Number", { fg = purple, bold = true })
    vim.api.nvim_set_hl(0, "Type", { fg = purple, bold = true })
    vim.api.nvim_set_hl(0, "Delimiter", { fg = orange, bold = true })
    vim.api.nvim_set_hl(0, "Identifier", { fg = orange })

    -- Status Line
    vim.api.nvim_set_hl(0, "StatusLine", { fg = black, bg = orange, bold = true })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#444444", bg = "#111111" })
    
    -- Line Numbers
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#444444" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = orange, bold = true })
    
    -- Indent Guides (IMPORTANT: All three must be set!)
    vim.api.nvim_set_hl(0, "NonText", { fg = purple })
    vim.api.nvim_set_hl(0, "IblIndent", { fg = purple })
    
    -- Make require and {} dark red
    vim.api.nvim_set_hl(0, "Special", { fg = "#8B0000" })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#8B0000" })
end

-- Apply theme
vim.api.nvim_create_autocmd({ "BufEnter", "ColorScheme" }, {
    callback = apply_nerv_theme
})
vim.cmd("colorscheme default")

-- Force apply theme after everything loads
vim.schedule(function()
  apply_nerv_theme()
end)

-- 5. DIAGNOSTICS
vim.diagnostic.config({
  virtual_text = { prefix = '❯', spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
})
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#FFA500" })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#FF0000", bold = true })

-- 6. STATUSLINE
vim.opt.statusline = "%#StatusLine# [NERV TACTICAL] %f %m %= %y %l:%c %p%% "
