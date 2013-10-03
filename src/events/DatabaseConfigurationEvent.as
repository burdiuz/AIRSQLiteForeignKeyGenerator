package events{
	import flash.events.Event;
	
	public class DatabaseConfigurationEvent extends Event{
		static public const DATABASE_CONFIGURATION_LOADED:String = "databaseConfigurationLoaded";
		private var _list:Array;
		public function DatabaseConfigurationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, list:Array=null):void{
			super(type, bubbles, cancelable);
			_list = list ? list : [];
		}
		public function get list():Array{
			return this._list.slice();
		}
		override public function clone():Event{
			return new DatabaseConfigurationEvent(this.type, this.bubbles, this.cancelable, this._list);
		}
	}
}