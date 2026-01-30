return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "nvim-lua/plenary.nvim", branch = "master" },
    build = "make tiktoken",
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
    opts = {},
  },
}
