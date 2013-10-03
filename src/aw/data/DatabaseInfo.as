package aw.data{
	import flash.data.SQLConnection;
	import flash.data.SQLSchema;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLTableSchema;
	import flash.data.SQLTriggerSchema;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	[Bindable]
	public class DatabaseInfo extends EventDispatcher{
		static public const DEFAULT_PAGE_SIZE:uint = 1024;
		private var _triggerNames:Object;
		private var _triggers:Array;
		private var _tableNames:Object;
		private var _tables:Array;
		private var _connection:SQLConnection;
		public var name:String;
		public var main:Boolean;
		public var autoCompact:Boolean;
		public var pageSize:uint = DEFAULT_PAGE_SIZE;
		public var encryptionKey:ByteArray;
		public var file:File;
		public function DatabaseInfo():void{
			super();
		}
		public function get tables():Array{
			return this._tables ? this._tables : this._tables.slice(); 
		}
		public function getTable(name:String):SQLTableSchema{
			return this._tableNames ? this._tableNames[name] : null; 
		}
		public function get triggers():Array{
			return this._triggers ? this._triggers : this._triggers.slice(); 
		}
		public function getTrigger(name:String):SQLTriggerSchema{
			return this._triggerNames ? this._triggerNames[name] : null; 
		}
		public function get connection():SQLConnection{
			return this._connection; 
		}
		public function read(connection:SQLConnection):void{
			if(!connection) throw new Error("\"connection\" parameter cannot be null");
			this._connection = connection;
			this._tableNames = {};
			this._tables = this.getDBSchema(SQLTableSchema, "tables", this.name, this._tableNames);
			this._triggerNames = {};
			this._triggers = this.getDBSchema(SQLTriggerSchema, "triggers", this.name, this._triggerNames);
		}
		private function getDBSchema(type:Class, property:String, database:String, hash:Object):Array{
			var list:Array;
			try{
				this._connection.loadSchema(type, null, database);
				var result:SQLSchemaResult = this.connection.getSchemaResult();
				list = result[property];
			}catch(error:Error){
				list = [];
			};
			for each(var item:SQLSchema in list){
				hash[item.name] = item;
			}
			list.sortOn("name");
			return list;
		}
		static public function create(file:File, name:String, main:Boolean=false, autoCompact:Boolean=false, pageSize:int=DEFAULT_PAGE_SIZE, encryptionKey:ByteArray=null):DatabaseInfo{
			const info:DatabaseInfo = new DatabaseInfo();
			info.file = file;
			info.name = name;
			info.main = main;
			info.autoCompact = autoCompact;
			info.pageSize = pageSize;
			info.encryptionKey = encryptionKey;
			return info;
		}
	}
}