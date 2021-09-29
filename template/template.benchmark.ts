'use strict';

import { Suite } 'benchmark';
import benchmarks 'beautify-benchmark';

const suite = Suite();

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
.run({ async: true });
