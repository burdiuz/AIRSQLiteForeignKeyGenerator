package commands{
	import flash.events.IEventDispatcher;
	
	public interface ICommand extends IEventDispatcher{
		function get errorOccured():Boolean;
		function get error():Error;
		function execute():void;
		function clear():void;
	}
}