# Public: Set a branch upstream.
#
# repo     - A Repo.
# callback - Receives `(err, result)`
#
module.exports = PI = (repo, options, callback) ->
  repo.git "push --set-upstream", {}, [options.remote,  options.branch], (err, stdout, stderr) ->
    status = new PushUpstream repo
    status.parse stdout
    return callback err, status

PI.PushUpstream = class PushUpstream
  constructor: (@repo) ->

  # Internal: return the result back to the user
  parse: (text) ->
    return text