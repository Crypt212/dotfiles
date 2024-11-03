if (1) then
    vim.cmd('hi Normal guibg=NONE ctermbg=NONE');
    vim.cmd('hi EndOfBuffer guibg=NONE ctermbg=NONE');
else
    -- define used colorscheme
    local colorscheme = 'monokai_pro'

    local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not is_ok then
        vim.notify("colorscheme " .. colorscheme .. " is not found!");
        return
    end
end
