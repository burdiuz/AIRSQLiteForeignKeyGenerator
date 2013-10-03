package aw.data{
	import spark.components.gridClasses.GridColumn;
	
	public class GridColumnExtension extends GridColumn{
		public var listField:String;
		public var listType:Class;
		public var truncatedHeaderText:String;
		public var referenceDatabaseField:String;
		public var referenceTableField:String;
		public var referenceColumnsField:String;
		public function GridColumnExtension(columnName:String=null):void{
			super(columnName);
			this.rendererIsEditable = true;
			this.editable = true;
		}
	}
}