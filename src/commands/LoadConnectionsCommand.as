package commands{
	import aw.data.SQLResources;
	
	import content.LoadDBResolvePathsPopUp;
	
	import events.DatabaseConfigurationEvent;
	
	import flash.events.Event;
	
	import mx.controls.Alert;

	public class LoadConnectionsCommand extends AbstractCommand implements ICommandFactory{
		public function LoadConnectionsCommand(completeHandler:Function=null):void{
			super(completeHandler);
		}
		public function getInstance():ICommand{
			return this;
		}
		override public function execute():void{
			const loadPopUp:LoadDBResolvePathsPopUp = LoadDBResolvePathsPopUp.display();
			loadPopUp.addEventListener(DatabaseConfigurationEvent.DATABASE_CONFIGURATION_LOADED, this.databaseConfigurationLoadedHandler);
		}
		protected function databaseConfigurationLoadedHandler(event:DatabaseConfigurationEvent):void{
			const list:Array = event.list;
			if(SQLResources.instance.setConfig(list)){
			}else{
				Alert.show("Unexpected error occured while adding databases to connection.", "Error adding Databases");
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}