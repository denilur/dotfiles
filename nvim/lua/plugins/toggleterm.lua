return {
    "akinsho/toggleterm.nvim",
    lazy = true,
    config = function()
        require("toggleterm").setup({
            direction = "float",
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.5
                end
            end,
        })
    end,
}
