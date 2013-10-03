package aw.data{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLSchema;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLTableSchema;
	import flash.data.SQLTriggerSchema;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	
	[Event(type="flash.events.Event", name="connect")]
	[Bindable]
	public class SQLResources extends EventDispatcher{
		static public const instance:SQLResources = new SQLResources();
		private var _databaseNames:Object;
		public var databases:FilteredArrayList;
		public var tables:FilteredArrayList;
		public var triggers:FilteredArrayList;
		public var connection:SQLConnection;
		public function SQLResources():void{
			super();
		}
		public function load(file:File, create:Boolean=false, autoCompact:Boolean=false, pageSize:uint=DatabaseInfo.DEFAULT_PAGE_SIZE, encryptionKey:ByteArray=null):Boolean{
			if(!this.loadInternal(file, create, autoCompact, pageSize, encryptionKey)) return false;
			this.refresh();
			return true;
		}
		private function loadInternal(file:File, create:Boolean, autoCompact:Boolean, pageSize:uint, encryptionKey:ByteArray):Boolean{
			try{
				this.connection = new SQLConnection();
				this.connection.open(file, create ? SQLMode.CREATE : SQLMode.UPDATE, autoCompact, pageSize, encryptionKey);
			}catch(error:Error){
				this.clear();
				return false;
			}
			const info:DatabaseInfo = DatabaseInfo.create(file, "main", true, autoCompact, pageSize, encryptionKey);
			this._databaseNames = {"main":info};
			this.databases = new FilteredArrayList("name", [info]);
			return true;
		}
		public function getDatabase(name:String):DatabaseInfo{
			return this._databaseNames && name in this._databaseNames ? this._databaseNames[name] : null;
		}
		public function attach(name:String, file:File, encryptionKey:ByteArray=null):Boolean{
			if(!this.attachInternal(name, file, encryptionKey)) return false;
			this.refresh();
			return true;
		}
		private function attachInternal(name:String, file:File, encryptionKey:ByteArray):Boolean{
			try{
				this.connection.attach(name, file, null, encryptionKey);
			}catch(error:Error){
				return false;
			}
			const info:DatabaseInfo = DatabaseInfo.create(file, name, false, false, DatabaseInfo.DEFAULT_PAGE_SIZE, encryptionKey);
			this._databaseNames[name] = info;
			this.databases.addItem(info);
			return true;
		}
		public function refresh():void{
			if(!this.connection) throw new Error("connection:SQLConnection should be specified first");
			var tables:Array = [];
			var triggers:Array = [];
			for each(var database:DatabaseInfo in this._databaseNames){
				database.read(this.connection);
				tables.push.apply(tables, database.tables);
				triggers.push.apply(triggers, database.triggers);
			}
			this.tables = new FilteredArrayList("database", tables);
			this.triggers = new FilteredArrayList("database", triggers);
			this.dispatchEvent(new Event(Event.CONNECT));
		}
		public function setConfig(list:Array):Boolean{
			const main:DatabaseInfo = SQLConnectionConfiguration.excludeMain(list);
			if(!main) return false;
			this.clear();
			this.loadInternal(main.file, false, main.autoCompact, main.pageSize, main.encryptionKey);
			for each(var info:DatabaseInfo in list){
				this.attachInternal(info.name, info.file, info.encryptionKey);
			}
			this.refresh();
			return true;
		}
		public function clear():void{
			if(this.connection){
				this.connection.close();
			}
			this.tables = null;
			this.triggers = null;
			this.connection = null;
			this.databases = null;
		}
		static public function createDatabaseFile(file:File, encryptionKey:ByteArray=null):Boolean{
			try{
				if(file.exists){
					file.deleteFile();
				}
				var connection:SQLConnection = new SQLConnection();
				connection.open(file, SQLMode.CREATE, false, 1024, encryptionKey);
				connection.close();
			}catch(error:Error){
				return false;
			}
			return true;
		}
		static public function uniqueSortSchemas(source:Array):Array{
			var list:Array = [];
			if(source){
				var hash:Object = {};
				var length:int = source.length;
				for(var index:int=0; index<length; index++){
					var item:SQLSchema = source[index];
					if(item.name in hash) continue;
					else{
						list.push(item);
						hash[item.name] = true; 
					}
				}
				list.sortOn("name", Array.CASEINSENSITIVE);
			}
			return list;
		}
	}
}