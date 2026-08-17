local M = {}

function M.load()
	-- ── Palette ───────────────────────────────────────────────────────────
	local bg = "#212121"
	local bg_panel = "#1c1c1c"
	local bg_float = "#242424"
	local bg_sel = "#2d4a48"
	local bg_line = "#272727"
	local fg = "#eeeeee"
	local fg_subtle = "#9e9e9e"
	local border = "#2c2c2c"
	local teal = "#80cbc4"
	local hint = "#26a69a"
	local blue = "#81d4fa"
	local green = "#a5d6a7"
	local yellow = "#fff59d"
	local orange = "#ffcc80"
	local red = "#ef9a9a"
	local red_bold = "#ef5350"
	local comment = "#626262"
	local lnum = "#3e3e3e"
	local lnum_act = "#6a6a6a"

	vim.cmd("highlight clear")
	vim.cmd("set termguicolors")

	local function hl(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- ── Editor ──────────────────────────────────────────────────────────
	hl("Normal", { fg = fg, bg = "NONE" })
	hl("NormalFloat", { fg = fg, bg = bg_float })
	hl("NormalNC", { fg = fg, bg = "NONE" })
	hl("CursorLine", { bg = bg_line })
	hl("CursorLineNr", { fg = lnum_act, bold = true })
	hl("LineNr", { fg = lnum })
	hl("SignColumn", { bg = "NONE" })
	hl("ColorColumn", { bg = bg_panel })
	hl("Visual", { bg = bg_sel })
	hl("VisualNOS", { bg = bg_sel })
	hl("Search", { fg = bg, bg = orange })
	hl("IncSearch", { fg = bg, bg = teal })
	hl("MatchParen", { fg = teal, bold = true, underline = true })

	-- ── Statusline & chrome ──────────────────────────────────────────────
	hl("StatusLine", { fg = fg_subtle, bg = bg_panel })
	hl("StatusLineNC", { fg = fg_subtle, bg = bg_panel })
	hl("WinSeparator", { fg = border })
	hl("FloatBorder", { fg = teal, bg = bg_float })
	hl("TabLine", { fg = fg_subtle, bg = bg_panel })
	hl("TabLineSel", { fg = fg, bg = bg })
	hl("TabLineFill", { bg = bg_panel })
	hl("Pmenu", { fg = fg, bg = bg_float })
	hl("PmenuSel", { fg = bg, bg = teal })
	hl("PmenuSbar", { bg = bg_panel })
	hl("PmenuThumb", { bg = fg_subtle })

	-- ── Syntax ──────────────────────────────────────────────────────────
	hl("Comment", { fg = comment, italic = true })
	hl("Keyword", { fg = teal })
	hl("Conditional", { fg = teal })
	hl("Repeat", { fg = teal })
	hl("Statement", { fg = teal })
	hl("Operator", { fg = fg_subtle })
	hl("Function", { fg = blue })
	hl("Identifier", { fg = fg })
	hl("Type", { fg = yellow })
	hl("StorageClass", { fg = yellow })
	hl("Structure", { fg = yellow })
	hl("Typedef", { fg = yellow })
	hl("String", { fg = green })
	hl("Character", { fg = green })
	hl("Number", { fg = orange })
	hl("Float", { fg = orange })
	hl("Boolean", { fg = orange })
	hl("Constant", { fg = orange })
	hl("Special", { fg = teal })
	hl("SpecialChar", { fg = hint })
	hl("Tag", { fg = red })
	hl("Delimiter", { fg = fg_subtle })
	hl("Punctuation", { fg = fg_subtle })
	hl("PreProc", { fg = teal })
	hl("Include", { fg = teal })
	hl("Define", { fg = teal })
	hl("Macro", { fg = teal })
	hl("Error", { fg = red_bold })
	hl("Todo", { fg = bg, bg = teal, bold = true })

	-- ── Treesitter ───────────────────────────────────────────────────────
	hl("@keyword", { fg = teal })
	hl("@keyword.function", { fg = teal })
	hl("@keyword.return", { fg = teal })
	hl("@function", { fg = blue })
	hl("@function.builtin", { fg = hint })
	hl("@function.call", { fg = blue })
	hl("@method", { fg = blue })
	hl("@method.call", { fg = blue })
	hl("@constructor", { fg = blue })
	hl("@type", { fg = yellow })
	hl("@type.builtin", { fg = yellow })
	hl("@string", { fg = green })
	hl("@string.escape", { fg = hint })
	hl("@string.regex", { fg = hint })
	hl("@number", { fg = orange })
	hl("@float", { fg = orange })
	hl("@boolean", { fg = orange })
	hl("@constant", { fg = orange })
	hl("@constant.builtin", { fg = orange })
	hl("@variable", { fg = fg })
	hl("@variable.builtin", { fg = red })
	hl("@variable.member", { fg = green })
	hl("@variable.parameter", { fg = fg_subtle, italic = true })
	hl("@property", { fg = green })
	hl("@attribute", { fg = blue })
	hl("@tag", { fg = red })
	hl("@tag.attribute", { fg = orange })
	hl("@tag.delimiter", { fg = fg_subtle })
	hl("@operator", { fg = fg_subtle })
	hl("@punctuation.bracket", { fg = fg_subtle })
	hl("@punctuation.delimiter", { fg = fg_subtle })
	hl("@comment", { fg = comment, italic = true })
	hl("@label", { fg = red })
	hl("@namespace", { fg = yellow })
	hl("@field", { fg = green })
	-- Rust-specific
	hl("@storageclass.lifetime", { fg = orange, italic = true })

	-- ── Diagnostics ──────────────────────────────────────────────────────
	hl("DiagnosticError", { fg = red_bold })
	hl("DiagnosticWarn", { fg = orange })
	hl("DiagnosticInfo", { fg = blue })
	hl("DiagnosticHint", { fg = hint })
	hl("DiagnosticUnderlineError", { undercurl = true, sp = red_bold })
	hl("DiagnosticUnderlineWarn", { undercurl = true, sp = orange })
	hl("DiagnosticUnderlineInfo", { undercurl = true, sp = blue })
	hl("DiagnosticUnderlineHint", { undercurl = true, sp = hint })

	-- ── Git ──────────────────────────────────────────────────────────────
	hl("GitSignsAdd", { fg = green })
	hl("GitSignsChange", { fg = yellow })
	hl("GitSignsDelete", { fg = red })
	hl("DiffAdd", { bg = "#1a2e1a" })
	hl("DiffChange", { bg = "#2e2c1a" })
	hl("DiffDelete", { fg = red, bg = "#2e1a1a" })
	hl("DiffText", { bg = "#3a3620" })

	-- ── Markdown ─────────────────────────────────────────────────────────
	hl("@markup.heading", { fg = fg, bold = true })
	hl("@markup.italic", { fg = blue, italic = true })
	hl("@markup.strong", { fg = blue, bold = true })
	hl("@markup.link.label", { fg = blue, italic = true })
	hl("@markup.link.url", { fg = hint })
	hl("@markup.raw", { fg = green })
	hl("@markup.list", { fg = orange })
end

return M
