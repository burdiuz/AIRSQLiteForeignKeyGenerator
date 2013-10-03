package commands{
	import content.OpenDatabasePopUp;
	
	import flash.events.Event;

	public class ExtendedOpenDBCommand extends AbstractCommand implements ICommandFactory{
		private var _create:Boolean;
		private var _popup:OpenDatabasePopUp;
		public function ExtendedOpenDBCommand(create:Boolean=false, completeHandler:Function=null):void{
			super(completeHandler);
			_create = create;
		}
		public function getInstance():ICommand{
			return this;
		}
		override public function execute():void{
			if(this._popup) return;
			const popup:OpenDatabasePopUp = OpenDatabasePopUp.display(this._create);
			popup.addEventListener(Event.CLOSE, this.popupCloseHandler);
			popup.addEventListener(Event.COMPLETE, this.popupCompleteHandler);
		}
		private function removePopup():void{
			if(!this._popup) return;
			this._popup.removeEventListener(Event.CLOSE, this.popupCloseHandler);
			this._popup.removeEventListener(Event.COMPLETE, this.popupCompleteHandler);
			this._popup = null;
		}
		private function popupCloseHandler(event:Event):void{
			this.removePopup();
		}
		private function popupCompleteHandler(event:Event):void{
			this.removePopup();
			this.dispatchEvent(event);
		}
	}
}