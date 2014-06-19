/*
 * lib/skinner-flattener.js: given a stream of node-skinner data points,
 * produce flattened output.
 */

var mod_jsprim = require('jsprim');
var mod_skinner = require('skinner');
var mod_util = require('util');
var mod_streamutil = require('./stream-util');
var PipelineStream = require('./stream-pipe');

module.exports = SkinnerFlattener;

/*
 * Given a stream of node-skinner data points, produce flattened points.
 * This implementation is comical and inefficient, but at least it's relatively
 * simple.
 */
function SkinnerFlattener(options)
{
	var skinnerOptions, stream, streamOptions;

	skinnerOptions = mod_jsprim.deepCopy(options.skinnerOptions);
	skinnerOptions.resultsAsPoints = false;

	stream = mod_skinner.createAggregator(skinnerOptions);
	streamOptions = mod_streamutil.streamOptions(options.streamOptions,
	    { 'objectMode': true });
	PipelineStream.call(this, {
	    'streams': [ stream ],
	    'streamOptions': streamOptions
	});
}

mod_util.inherits(SkinnerFlattener, PipelineStream);