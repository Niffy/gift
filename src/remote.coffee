# Public: Create a Remote.
#
# repo     - A Repo.
# callback - Receives `(err, status)`
#
module.exports = R = (repo, options, callback) ->
  repo.git "remote", options, (err, stdout, stderr) ->
    remote = new Remote repo
    resp = remote.parse stdout
    return callback err, resp

R.Remote = class Remote
  constructor: (@repo) ->

  # Internal: Parse the remote names from stdout of a `git remote` command.
  parse: (text) ->
    @names = []
    for line in text.split("\n")
      if line
        @names.push line

    return @names