trigger HelloWorldTrigger on Account (after insert) {
	System.debug('Hello World!');
}