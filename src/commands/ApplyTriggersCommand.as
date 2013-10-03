package commands{
	import mx.controls.Alert;

	public class ApplyTriggersCommand extends AbstractCommand implements ICommandFactory{
		public function ApplyTriggersCommand(completeHandler:Function=null):void{
			super(completeHandler);
		}
		override public function execute():void{
			Alert.show("Applying triggers to current connections...");
		}
		public function getInstance():ICommand{
			return this;
		}
	}
}