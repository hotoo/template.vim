'use strict';

const Benchmark = require('benchmark');
const benchmarks = require('beautify-benchmark');

const suite = new Benchmark.Suite();

suite
.add('implemention 1', function() {
  // ${cursor}
})
.add('implemention 2', function() {
  // implemention 2
})
.on('cycle', function(event) {
  benchmarks.add(event.target);
})
.on('complete', function() {
  benchmarks.log();
})
.run({async: true});
