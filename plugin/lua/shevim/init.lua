local configs = {
    python={
        regex="^#!/usr/bin/env python$",
        filetype="python"
    },
    node={
        regex="^#!/usr/bin/env node$",
        filextensions={
            ts="typescript",
            js="javascript",
        }
    }
}

function setFiletypeBasedOnShebang(filetype)
    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
    for _, line in ipairs(lines) do
        -- If line is empty, then go to next.
        if line ~= "" then
            for k, v in pairs(configs) do
                local result = string.match(line, v.regex)
                if result ~= nil then 
                    return assignFiletype(v, filetype)
                end
            end
            -- Return here since the first non empty line should have the shebang
            -- If nothing matches here, so be it.
            return
        end
    end
end

function assignFiletype(configObject, filextension)
    if configObject.filetype ~= nil then
        vim.bo.filetype = configObject.filetype
    elseif configObject.filextensions ~= nil and configObject.filextensions[filextension] ~= nil then
        vim.bo.filetype = configObject.filextensions[filextension]
    end
end

function getFileExtensionAndMatchShebang()
    setFiletypeBasedOnShebang(vim.fn.expand('%:e'))
end


local auGroup = vim.api.nvim_create_augroup("Shevim", {
    clear=true,
})

vim.api.nvim_create_autocmd({"BufEnter"}, {
    callback = getFileExtensionAndMatchShebang,
    pattern = "*",
    group = auGroup,
})
