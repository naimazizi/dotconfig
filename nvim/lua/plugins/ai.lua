return {
  -- Disable avante in favor of copilot.lua + codecompanion.nvim
  {
    "yetone/avante.nvim",
    enabled = false,
    vscode = false,
    event = "VeryLazy",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/which-key.nvim",
      "folke/snacks.nvim",
      "zbirenbaum/copilot.lua",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        vscode = false,
        ft = function(_, ft)
          vim.list_extend(ft, { "Avante" })
        end,
        opts = function(_, opts)
          opts.file_types = vim.list_extend(opts.file_types or {}, { "Avante" })
        end,
      },
    },
    opts = {
      mode = "agentic",
      -- Default configuration
      hints = { enabled = true },

      ---@alias AvanteProvider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "copilot", -- Recommend using Claude
      auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot

      -- File selector configuration
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "snacks", -- Avoid native provider issues
        provider_opts = {
          -- Additional snacks.input options
          title = "Avante Input",
          icon = " ",
        },
      },
      windows = {
        position = "left",
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      require("which-key").add({ "<leader>a", group = "avante (ai)" })
    end,
    build = "make",
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    vscode = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
      },
      "ravitemer/codecompanion-history.nvim",
    },
    config = function()
      ---@diagnostic disable-next-line: need-check-nil
      require("codecompanion").setup({
        memory = {
          opts = {
            chat = {
              enabled = true,
            },
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 5,
            prompt = "Prompt ",
            provider = "snacks",
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
              title = "CodeCompanion actions", -- The title of the action palette
            },
          },
        },
        extensions = {
          history = {
            enabled = true,
            opts = {
              picker = "snacks",
            },
            -- -- Memory system (requires VectorCode CLI)
            -- memory = {
            --   -- Automatically index summaries when they are generated
            --   auto_create_memories_on_summary_generation = true,
            --   -- Path to the VectorCode executable
            --   vectorcode_exe = "vectorcode",
            --   -- Tool configuration
            --   tool_opts = {
            --     -- Default number of memories to retrieve
            --     default_num = 10,
            --   },
            --   -- Enable notifications for indexing progress
            --   notify = true,
            --   -- Index all existing memories on startup
            --   -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
            --   index_on_startup = true,
            -- },
          },
        },
        prompt_library = {
          ["Inline comments"] = {
            strategy = "chat",
            description = "Write comments for me",
            opts = {
              index = 11,
              is_slash_cmd = false,
              auto_submit = false,
              short_name = "comment",
            },
            prompts = {
              {
                role = "user",
                content = "Add explanatory inline comments to the following code, clarifying complex logic and variable purposes",
              },
            },
          },
          ["Fix language"] = {
            strategy = "chat",
            description = "Fix language",
            opts = {
              index = 12,
              auto_submit = true,
              short_name = "fixlang",
            },
            prompts = {
              {
                role = "user",
                content = "Make the sentence better and more concise:",
              },
            },
          },
          ["Code Expert"] = {
            strategy = "chat",
            description = "Get some special advice from an LLM",
            opts = {
              index = 13,
              short_name = "expert",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = true,
            },
            prompts = {
              {
                role = "system",
                content = function(context)
                  return "I want you to act as a senior "
                    .. context.filetype
                    .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
                end,
              },
              {
                role = "user",
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
        },
      })

      require("which-key").add({
        { "<leader>a", desc = "+ai", icon = "" },
      })

      vim.keymap.set(
        { "n", "v" },
        "<leader>at",
        "<cmd>CodeCompanionActions<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Actions" }
      )
      vim.keymap.set(
        { "n", "v" },
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Toggle" }
      )
      vim.keymap.set(
        "v",
        "<leader>ad",
        "<cmd>CodeCompanionChat Add<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Add selection" }
      )
      vim.keymap.set(
        "n",
        "<leader>ah",
        "<cmd>CodeCompanionHistory<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion History" }
      )

      -- Custom Prompts
      vim.keymap.set(
        "v",
        "<leader>ac",
        "<cmd>CodeCompanion /comment<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Add inline comments" }
      )
      vim.keymap.set(
        "v",
        "<leader>ag",
        "<cmd>CodeCompanion /fixlang<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Fix language" }
      )
      vim.keymap.set(
        "v",
        "<leader>ax",
        "<cmd>CodeCompanion /expert<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Prompt Code Expert" }
      )

      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
}
