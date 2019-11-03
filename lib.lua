function translate(package, key, ...)
    if translations == nil then
        return "i18n_not_ready"
    end
    if translations[package] == nil then
        return "i18n_missing_package"
    end
    if translations == nil or translations[package] == nil then
        return "i18n_missing_package"
    end
    if translations[package][key] == nil then
        return "i18n_missing_key"
    end
    local text = translations[package][key]
    local params = {...}
    for i=1,#params do
        text = text:gsub("{"..i.."}", params[i])
    end
    return text
end

AddFunctionExport("translate", translate)
AddFunctionExport("t", translate)
AddFunctionExport("_", translate)
