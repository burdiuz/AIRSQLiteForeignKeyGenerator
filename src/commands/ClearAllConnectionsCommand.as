package commands{
	import flash.events.Event;

	public class ClearAllConnectionsCommand extends AbstractCommand implements ICommandFactory{
		public function ClearAllConnectionsCommand(completeHandler:Function=null):void{
			super(completeHandler);
		}
		public function getInstance():ICommand{
			return this;
		}
		override public function execute():void{
			this.resources.clear();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}