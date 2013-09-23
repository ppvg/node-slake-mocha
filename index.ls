{flatten, is-type, keys} = require \prelude-ls
{spawn} = require \child_process
{defer} = require \when
require! \path

mochaPath = require.resolve \mocha/bin/_mocha

module.exports = mocha

# Run mocha tests. Returns a promise, which will be fulfilled or rejected
# based on `mocha`'s exit code.
#
#     mocha([opts], file, [...files])
#
# Almost all options (see http://visionmedia.github.io/mocha/#usage) are
# available. For instance:
#
#     mocha colors:true, ui:\TDD, growl:true, 'test/*'
#
# One extra option is the `io` option, which you can use to bind to the
# `stdio` of the child process. It's set to `'ignore'` by default.
#
# The `compilers` option takes an array and is set to `['ls:LiveScript']`
# by default. If you override it, but still want the LiveScript compiler,
# you will have to manually add it.
#
# The file arguments may be strings or arrays, which will be flattened.
#
function mocha ...args
  {opts, files} = incoming args
  io = if opts.io? then opts.io else \ignore
  delete opts.io
  deferred = defer!

  mochaArgs = (outgoing opts) ++ files
  process = spawn \mocha, mochaArgs, { stdio: io }
  process.on \exit, (code, signal) ->
    if signal? or code isnt 0 then deferred.reject!
    else deferred.resolve!

  return deferred.promise

  function incoming args
    opts = if is-type \Object, args[0] then args.shift! else {}
    {opts, files: flatten args}

  function outgoing opts
    if not opts.compilers? then opts.compilers = [\ls:LiveScript]

    args = []
    if opts.r or opts.require then args.push \-r, that
    if opts.R or opts.reporter then args.push \-R, that
    if opts.u or opts.ui then args.push \-ui, that
    if opts.t or opts.timeout then args.push \-t, that
    if opts.s or opts.slow then args.push \-s, that
    if opts.w or opts.watch then args.push \-w
    if opts.c or opts.colors then args.push \-c
    if opts.C or opts.\no-colors or opts.noColors then args.push \-C
    if opts.G or opts.growl then args.push \-G
    if opts.b or opts.bail then args.push \-b
    if opts.recursive then args.push \--recursive
    if opts.compilers?length
      args.push \--compilers
      args.push opts.compilers.join!

    args ++ files

