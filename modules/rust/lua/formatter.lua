require("conform").setup({
    formatters_by_ft = {
        nix = {
            "alejandra",
        },
        rust = {
            "rustfmt",
        },
    },
})
