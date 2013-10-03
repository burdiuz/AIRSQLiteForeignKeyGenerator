package aw.data{
	import aw.file.FileUtils;
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;

	public class SQLConnectionConfiguration extends Object{
		static public const FILE_EXTENSION:String = "dbconnections";
		static public const FILE_FILTER:FileFilter = new FileFilter("Database connections configuration file", "*.dbconnections");
		static public const MAIN_DB_NAME:String = "main";
		static private const _base64Encoder:Base64Encoder = new Base64Encoder();
		static private const _base64Decoder:Base64Decoder = new Base64Decoder();
		static public function load(file:File):Array{
			var xml:XML = new XML(FileUtils.read(file).toString());
			var list:Array;
			if(xml.@path.length()){
				list = [DatabaseInfo.create(
					new File(xml.@path), 
					MAIN_DB_NAME, 
					true, 
					String(xml.@autoCompact)=="1", 
					xml.@pageSize.length() ? uint(xml.@pageSize) : DatabaseInfo.DEFAULT_PAGE_SIZE, 
					getEncryptionKeyFromXML(xml)
				)];
				for each(var node:XML in xml.elements()){
					if(node.@path.length() && node.@name.length()){
						list.push(DatabaseInfo.create(new File(node.@path), node.@name, false, false, DatabaseInfo.DEFAULT_PAGE_SIZE, getEncryptionKeyFromXML(node)));
					}
				}
			}
			return list;
		}
		static private function getEncryptionKeyFromXML(node:XML):ByteArray{
			var encryptionKey:ByteArray = null;
			if(node.@encryptionKey.length()){
				_base64Decoder.decode(node.@encryptionKey);
				encryptionKey = _base64Decoder.toByteArray();
			}
			return encryptionKey;
		}
		static public function save(file:File, list:*):void{
			const xml:XML = getConfigXML(list);
			FileUtils.writeString("<?xml version=\"1.0\"?>\n"+xml.toXMLString(), file);
		}
		static public function getConfigXML(list:*):XML{
			var bytes:ByteArray;
			const xml:XML = <configuration/>;
			for each(var info:DatabaseInfo in list){
				if(info.name==MAIN_DB_NAME){
					xml.@name = MAIN_DB_NAME;
					xml.@path = info.file.nativePath;
					xml.@autoCompact = info.autoCompact ? "1" : "0";
					xml.@pageSize = info.pageSize;
					bytes = info.encryptionKey;
					if(bytes){
						_base64Encoder.encodeBytes(bytes, 0, bytes.length);
						xml.@encryptionKey = _base64Encoder.toString();
					}
				}else{
					var node:XML = <attach name={info.name} path={info.file.nativePath}/>;
					bytes = info.encryptionKey;
					if(bytes){
						_base64Encoder.encodeBytes(bytes, 0, bytes.length);
						node.@encryptionKey = _base64Encoder.toString();
					}
					xml.* += node;
				}
			}
			return xml;
		}
		static public function getFileName(list:*, useDate:Boolean=true):String{
			const names:Array = [];
			for each(var info:DatabaseInfo in list) names.push(info.name);
			names.sort(Array.CASEINSENSITIVE);
			var name:String = "";
			if(useDate){
				const date:Date = new Date();
				const month:String = String(date.month+1);
				const day:String = String(date.date);
				name = date.fullYear+"_"+(month.length>1 ? month : "0"+month)+"_"+(day.length>1 ? day : "0"+day)+"_";
			}
			name += names.join("_");
			return name+"."+FILE_EXTENSION;
		}
		static public function excludeMain(list:Array):DatabaseInfo{
			for(var index:* in list){
				var info:DatabaseInfo = list[index];
				if(info.main){
					list.splice(index, 1);
					return info;
				}
			}
			return null;
		}
	}
}