package aw.data{
	
	import flash.data.SQLTableSchema;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	import aw.file.FileUtils;

	[Bindable]
	[RemoteClass("ForeignKeyInfo")]
	public class ForeignKeyInfo extends EventDispatcher{
		static private var _ids:int = 0;
		public var id:int;
		private var _name:String;
		private var _database:String;
		private var _table:String;
		private var _fieldNames:String;
		private var _referenceDatabase:String;
		private var _referenceTable:String;
		private var _referenceFieldNames:String;
		private var _onDelete:ForeignKeyAction;
		private var _onUpdate:ForeignKeyAction;
		public function ForeignKeyInfo():void{
			super();
			this.id = ++_ids;
		}
		public function get onUpdate():ForeignKeyAction{
			return _onUpdate;
		}
		public function set onUpdate(action:ForeignKeyAction):void{
			_onUpdate = action ? ForeignKeyAction.getByValue(action.value) : ForeignKeyAction.NO_ACTION;
		}
		public function get onDelete():ForeignKeyAction{
			return _onDelete;
		}
		public function set onDelete(action:ForeignKeyAction):void{
			_onDelete = action ? ForeignKeyAction.getByValue(action.value) : ForeignKeyAction.NO_ACTION;
		}
		public function get name():String{
			return this._name;
		}
		public function set name(value:String):void{
			this._name = value;
		}
		public function get database():String{
			return this._database;
		}
		public function set database(value:String):void{
			this._database = value;
		}
		public function get table():String{
			return this._table;
		}
		
		public function set table(value:String):void{
			this._table = value;
		}
		public function get columns():String{
			return this._fieldNames;
		}
		public function set columns(value:String):void{
			this._fieldNames = value;
		}
		public function get referenceDatabase():String{
			return this._referenceDatabase;
		}
		public function set referenceDatabase(value:String):void{
			this._referenceDatabase = value;
		}
		public function get referenceTable():String{
			return this._referenceTable;
		}
		public function set referenceTable(value:String):void{
			this._referenceTable = value;
		}
		public function get referenceColumns():String{
			return this._referenceFieldNames;
		}
		public function set referenceColumns(value:String):void{
			this._referenceFieldNames = value;
		}
		public function setSilent(name:String, value:String):void{
			this["_"+name] = value;
		}
		static public function getTableSchema(tableName:String, dbName:String="", resources:SQLResources=null):SQLTableSchema{
			var table:SQLTableSchema;
			if(!resources) resources = SQLResources.instance;
			var db:DatabaseInfo = resources.getDatabase(dbName ? dbName : "main");
			if(db){
				table = db.getTable(tableName);
			}
			return table;
		}
		static public function columnsToList(columns:String):Array{
			return columns ? columns.match(/[^,;\s]+/ig) : [];
		}
		static public function columnsToString(columns:Array):String{
			return columns ? columns.join(",") : "";
		}
		static public function save(file:File, list:Array):void{
			const bytes:ByteArray = new ByteArray();
			bytes.writeObject(list);
			FileUtils.write(bytes, file);
		}
		static public function load(file:File):Array{
			const bytes:ByteArray = FileUtils.read(file);
			bytes.position = 0;
			const list:Array = bytes.readObject();
			return list;
		}
	}
}