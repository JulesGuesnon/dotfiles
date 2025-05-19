local Util = require("lazyvim.util")

return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
      end,
      desc = "Explorer NeoTree (root)",
    },
  },
  opts = {
    window = {
      mappings = {
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["P"] = {
          function(state)
            local to_paste = vim.fn.getreg("+")

            local node = state.tree:get_node()

            if node.type == "file" then
              local target = vim.fs.dirname(node.path)

              local cmd = string.format("cp -r %s %s", to_paste, target)

              os.execute(cmd)
            end

            if node.type == "directory" then
              local cmd = string.format("cp -r %s %s", to_paste, node.path)

              os.execute(cmd)
            end
          end,
          desc = "Paste from Clipboard",
        },
      },
    },
  },
}
