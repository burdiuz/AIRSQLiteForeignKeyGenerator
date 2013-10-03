package commands{
	import content.ExportTriggersWindow;
	
	import flash.events.Event;

	public class ExportTriggersCommand extends AbstractCommand implements ICommandFactory{
		public function ExportTriggersCommand(completeHandler:Function=null):void{
			super(completeHandler);
		}
		override public function execute():void{
			const popUp:ExportTriggersWindow = ExportTriggersWindow.display();
			popUp.addEventListener(Event.CLOSE, this.popupCloseHandler);
		}
		private function popupCloseHandler(event:Event):void{
			dispatchEvent(new Event(Event.COMPLETE));
		}	
		public function getInstance():ICommand{
			return this;
		}
	}
}