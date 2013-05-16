# Description:
#   A simple karma tracking script for hubot.
#
# Commands:
#   karma <mention name>
#   karma all
#   <mention name>++
#   <mention name>--

module.exports = (robot) ->

  robot.hear /^@?(.*?)(\+\+|--)/, (response) ->
    user = response.message.user.mention_name
    mention_name = response.match[1].trim()
    return response.send "Hey, you can't give yourself karma!" if user is mention_name
    op = response.match[2]
    v = inc mention_name, (if op is "++" then 1 else -1)
    response.send "#{mention_name} now has #{v} karma."

  robot.hear /^karma (?:@?(.*))?/, (response) ->
    mention_name = response.match[1].trim()
    msg =
      if mention_name.toLowerCase() is "all"
        all = karma()
        list = Object.keys(all)
          .map((k) -> [k, all[k]])
          .sort((a, b) -> if a[1] < b[1] then 1 else if a[1] > b[1] then -1 else 0)
          .map((pair) -> pair.reverse().join " ")
        if list.length > 0
          "Karma for all known users:\n#{list.join '\n'}"
        else
          "I'm not tracking karma for any users yet."
      else
        "#{mention_name} has #{get mention_name} karma."
    response.send msg

  karma = ->
    all = robot.brain.get "karma"
    if not all
      all = {}
      robot.brain.set "karma", all
    all

  get = (name) ->
    karma()[name] or 0

  set = (name, v) ->
    karma()[name] = v

  inc = (name, mod) ->
    set name, get(name) + mod
