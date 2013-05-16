# Description:
#   A simple karam tracking script for hubot.
#
# Commands:
#   <mention name>++
#   <mention name>--

module.exports = (robot) ->

  robot.hear /^(.*?)(\+\+|--)/, (msg) ->
    mention_name = msg.match[1].trim()
    op = msg.match[2]
    update mention_name, (v) -> v + (if op is "++" then 1 else -1)

  update = (mention_name, opfn) ->
    k = "karma:#{mention_name}"
    v = robot.brain.get k
    v = if v? then opfn v else 0
    robot.brain.set k, v
