package aw.data{
	import flash.data.SQLColumnSchema;
	import flash.data.SQLSchema;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class TableColumnInfo extends EventDispatcher{
		public var name:String;
		public var schema:SQLColumnSchema;
		public var selected:Boolean;
		public function TableColumnInfo(schema:SQLColumnSchema=null):void{
			super();
			if(schema){
				this.schema = schema;
				this.name = schema.name;
			}
		}
		public function isExists():Boolean{
			return Boolean(this.schema);
		}
		static public function toString(schema:SQLColumnSchema, short:Boolean=false):String{
			var label:String = schema.name+": "+schema.dataType;
			if(schema.autoIncrement) label += (short ? " AI" : " AUTOINCREMENT");
			if(schema.primaryKey) label += (short ? " PK" : " PRIMARYKEY");
			return label+(schema.allowNull ? " NULL" : " NOT NULL");
		}
	}
}