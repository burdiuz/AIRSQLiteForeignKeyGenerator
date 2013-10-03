package aw.data{
	import flash.data.SQLResult;

	public class SQLResultLog{
		static public function show(result:SQLResult, handler:Function=null):void{
			showArrayOf(result.data, handler);
		}
		static public function showArrayOf(list:Array, handler:Function=null):void{
			if(handler==null) handler = trace;
			var row:String;
			for(var index:String in list){
				var object:Object = list[index];
				row = "#"+index;
				var started:Boolean = false;
				for(var param:String in object){
					row += (started ? ",\t" : "\t")+param+"=\""+object[param]+"\"";
					started = true;
				}
				handler(row);
			}
		}
	}
}