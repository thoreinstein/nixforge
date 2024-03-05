
require("conform").setup({
	formatters_by_ft = {
		terraform = {
			"terraform_fmt",
		},
		nix = {
			"alejandra",
		},
	},
})
