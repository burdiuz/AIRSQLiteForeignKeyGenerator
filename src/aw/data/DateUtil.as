package aw.data{
	public class DateUtil{
		static public function format(value:Date=null, time:Boolean=false):String{
			if(!value) value = new Date();
			const month:String = String(value.month+1);
			const date:String = String(value.date);
			var string:String = value.fullYear+"."+(month.length<2 ? "0" : "")+month+"."+(date.length<2 ? "0" : "")+date;
			if(time){
				var minutes:String = String(value.minutes);
				var seconds:String = String(value.seconds);
				string += " "+value.hours+":"+(minutes.length<2 ? "0" : "")+minutes+":"+(seconds.length<2 ? "0" : "")+seconds;
			}
			return string;
		}
	}
}