package aw.data.export{
	import aw.data.ForeignKeyInfo;
	import aw.data.SQLCommandType;
	
	import flash.data.SQLStatement;
	
	import mx.collections.IList;
	
	public class SQLiteExport extends Object implements IDataExport{
		public function SQLiteExport():void{
			super();
		}
		public function create(list:IList):String{
			var string:String = "";
			if(list){
				var length:int = list.length;
				for(var index:int=0; index<length; index++){
					var item:ForeignKeyInfo = list.getItemAt(index) as ForeignKeyInfo;
					if(item){
						string += SQLiteExport.create(item);
					}
				}
			}
			return string;
		}
		static public function create(item:ForeignKeyInfo):String{
			return createINSERT(item)+createUPDATE(item)+createDELETE(item);
		}
		static public function createINSERT(item:ForeignKeyInfo):String{
			var statement:SQLStatement = new SQLStatement();
			statement.text = 
			"CREATE TRIGGER ?\r\n"+
			"	BEFORE INSERT ON ?\r\n"+
			"	FOR EACH ROW BEGIN\r\n"+
			"		SELECT RAISE(ROLLBACK, \"?\")\r\n"+
			"	WHERE (\r\n"+
			"		SELECT 1 FROM ?\r\n"+ 
			"		WHERE ? \r\n"+
			"		LIMIT 0, 1\r\n"+
			"	) IS NULL;\r\n"+
			"END;\r\n";
			var where:Array = [];
			var columns:Array = ForeignKeyInfo.columnsToList(item.columns);
			var refColumns:Array = ForeignKeyInfo.columnsToList(item.referenceColumns);
			var length:int = Math.min(columns.length, refColumns.length);
			for(var index:int=0; index<length; index++){
				where.push(" NEW."+columns[index]+" = "+refColumns[index]);
			}
			statement.parameters["0"] = Settings.instance.getTriggerName(item, SQLCommandType.INSERT); 
			statement.parameters["1"] = item.database ? item.database+"."+item.table : item.table; 
			statement.parameters["2"] = Settings.instance.onInsertErrorMessage;
			statement.parameters["3"] = item.referenceDatabase ? item.referenceDatabase+"."+item.referenceTable : item.referenceTable;
			statement.parameters["4"] = where.join(" AND ");
			return statement.toString();
		}
		static public function createUPDATE(item:ForeignKeyInfo):String{
			var string:String = "";
			return string;
		}
		static public function createDELETE(item:ForeignKeyInfo):String{
			var string:String = "";
			return string;
		}
	}
}