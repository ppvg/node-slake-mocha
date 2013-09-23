Helper functions for working with [mocha][mocha] from your `Slakefile`. Work in progress, with a promise-based API.

  [mocha]: http://visionmedia.github.io/mocha/

Installation and usage
======================

Installation: `npm install git://github.com/PPvG/node-slake-mocha.git`. It may be published on npm in the future, probably as `slake-mocha`.

Usage: simply require it at the top of your `Slakefile`. The helpers have a promise-based API:

    mocha = require \slake-mocha

    task \test ->
      options =
        colors: true
        growls: true
        reporter: \spec
      mocha options, \./test/*

API
===

`mocha`
-------

Run mocha tests. Returns a promise, which will be fulfilled or rejected based on `mocha`'s exit code.

   mocha([opts], file, [...files])

Almost all of the [command-line options][opts] are available. For instance:

    mocha colors:true, ui:\TDD, growl:true, 'test/*'

One extra option is the `io` option, which you can use to bind to the `stdio` of the child process (see [`child_process.spawn`][spawn] for details). It's set to `'ignore'` by default.

The `compilers` option takes an array and is set to `['ls:LiveScript']` by default. If you override it, but still want the LiveScript compiler, you will have to manually add it.

  [opts]: http://visionmedia.github.io/mocha/#usage)
  [spawn]: http://nodejs.org/api/child_process.html#child_process_child_process_spawn_command_args_options

The file arguments may be strings or arrays, which will be flattened:

    mocha \tests/*, [\alt/tests/*, \./single-test]

