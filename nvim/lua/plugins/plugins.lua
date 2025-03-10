-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  { "RRethy/nvim-base16" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "base16-tomorrow-night",
    },
  },
  { "tpope/vim-surround" },
  { "tpope/vim-fugitive" },
  {
    "tpope/vim-eunuch",
    dependencies = { "tpope/vim-repeat" },
    keys = {
      { "<leader><leader>r", ":Rename ", desc = "Rename current file" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- From receipes to setup supertab behaviour
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- Append emoji source
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }, 1, 1))

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "gopls",
        "gospel",
        "gofumpt",
        "goimports",
        -- "flake8",
      },
    },
  },
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>R", ":w<cr> :TestNearest<cr>", desc = "Run nearest test", silent = true },
      { "<leader>c", ":w<cr> :TestClass<cr>", desc = "Run test class", silent = true },
      { "<leader>r", ":w<cr> :TestFile<cr>", desc = "Run test file", silent = true },
      { "<leader>a", ":w<cr> :TestSuite<cr>", desc = "Run test suite", silent = true },
      { "<leader>l", ":w<cr> :TestLast<cr>", desc = "Run last test", silent = true },
      { "<leader>g", ":w<cr> :TestVisit<cr>", desc = "Run test in last visited test file", silent = true },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
    end,
  },
  -- Language syntax support
  { "HerringtonDarkholme/yats.vim" },
  { "aklt/plantuml-syntax" },
  { "chr4/nginx.vim" },
  { "hashivim/vim-packer" },
  { "hashivim/vim-terraform" },
  { "jparise/vim-graphql" },
  { "maxmellon/vim-jsx-pretty" },
  { "pearofducks/ansible-vim" },
  { "towolf/vim-helm" },
  { "tpope/vim-rails" },
  { "tpope/vim-rake" },
  { "vim-ruby/vim-ruby" },
  { "wuelnerdotexe/vim-astro" },
  { "yuezk/vim-js" },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  -- copilot
  { "github/copilot.vim" },
}
