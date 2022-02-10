'use strict';

import { Suite } from 'benchmark';
import benchmarks from 'beautify-benchmark';

const suite = new Suite();

suite
.add('implemention 1', function() {
  // ${cursor}
})
.add('implemention 2', function() {
  // implemention 2
})
.on('cycle', function(event: any) {
  benchmarks.add(event.target);
})
.on('complete', function() {
  benchmarks.log();
})
.run({ async: true });
