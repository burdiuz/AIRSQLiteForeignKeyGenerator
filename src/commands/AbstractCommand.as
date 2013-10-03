package commands{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import aw.data.SQLResources;
	
	[Event(name="init", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	public /*abstract*/ class AbstractCommand extends EventDispatcher implements ICommand{
		public const settings:Settings = Settings.instance;
		public const resources:SQLResources = SQLResources.instance;
		protected var _errorOccured:Boolean;
		protected var _error:Error;
		public function AbstractCommand(completeHandler:Function=null):void{
			super();
			if(Object(this).constructor==AbstractCommand){
				throw new Error("AbstractCommand class cannot be instantiated.");
			}
			if(completeHandler!=null){
				this.addEventListener(Event.COMPLETE, completeHandler);
			}
		}
		public function get errorOccured():Boolean{
			return this._errorOccured;
		}
		public function get error():Error{
			return this._error;
		}
		public /*abstract*/ function execute():void{
			throw new Error("AbstractCommand.execute() method should be overwritten in subclasses.");
		}
		public /*abstract*/ function clear():void{
			throw new Error("AbstractCommand.clear() method should be overwritten in subclasses.");
		}
	}
}