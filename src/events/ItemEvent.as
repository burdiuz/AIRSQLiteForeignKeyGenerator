package events{
	import flash.events.Event;
	
	public class ItemEvent extends Event{
		static public const ITEM_DELETE:String = "itemDelete";
		static public const ITEM_MOVE_UP:String = "itemMoveUp";
		static public const ITEM_MOVE_DOWN:String = "itemMoveDown";
		private var _item:*;
		public function ItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, item:*=null):void{
			super(type, bubbles, cancelable);
			_item = item;
		}
		public function get item():*{
			return this._item;
		}
		override public function clone():Event{
			return new ItemEvent(this.type, this.bubbles, this.cancelable, this._item);
		}
	}
}