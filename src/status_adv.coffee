# Public: Create a Status.
#
# repo     - A Repo.
# callback - Receives `(err, status)`
#
module.exports = S = (repo, options, callback) ->
  repo.git "status", options, (err, stdout, stderr) ->
    status = new Status repo
    status.parse stdout
    return callback err, status

S.Status = class Status
  constructor: (@repo) ->
    @regYourBranch = new RegExp /Your branch/gi
    @regAhead = new RegExp /Ahead/gi
    @regBehind = new RegExp /Behind/gi
    @regDiverged = new RegExp /Diverged/gi
    @regUpToDate = new RegExp /up-to-date/gi
    @regCommitCount = new RegExp /(?:by )(\w)(?: commit)/gi

  getCommitCount: (line) ->
    sub1 = line.match @regCommitCount
    sub1 = sub1.toString().replace('by', '')
    sub1 = sub1.replace('commit','')
    sub1 = sub1.trim()
    try 
      sub1 = parseInt sub1
    catch err
      console.log 'Opps err', err
    
    return sub1

  # Internal: Parse the status from stdout of a `git status` command.
  parse: (text) ->
    @status = {}
    @status.ahead = false
    @status.behind = false
    @status.diverged = false
    @status.upToDate = false
    @status.detected = false
    @status.commitCount = 0
    @clean = text.length == 0
    for line in text.split("\n")
      if line.match @regYourBranch
        if line.match @regAhead
          @status.ahead = true
          @status.detected = true
          @status.commitCount = this.getCommitCount line
        if line.match @regBehind
          @status.behind = true
          @status.commitCount = this.getCommitCount line
        if line.match @regDiverged
          @status.diverged = true
          @status.detected = true
        if line.match @regUpToDate
          @status.upToDate = true
          @status.detected = true
    return @status