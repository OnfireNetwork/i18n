translations = {}
local file_transfers = {}

AddRemoteEvent("i18n_start_file", function(package, length)
    file_transfers[package] = {
        length = length,
        content = ""
    }
end)

AddRemoteEvent("i18n_send_file_data", function(package, data)
    file_transfers[package].content = file_transfers[package].content..data
    if file_transfers[package].content:len() == file_transfers[package].length then
        translations[package] = json_decode(file_transfers[package].content)
        file_transfers[package] = nil
    end
end)

AddRemoteEvent("i18n_ready", function(package)
    CallEvent("OnTranslationReady")
end)