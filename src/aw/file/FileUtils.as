/**
 * Created with IntelliJ IDEA.
 * User: Oleg Galabura
 * Date: 28.01.13
 * Time: 13:45
 * To change this template use File | Settings | File Templates.
 */
package aw.file {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;


	public class FileUtils {
		static public function read(file:File):ByteArray{
			const stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			const bytes:ByteArray =  new ByteArray();
			stream.readBytes(bytes, 0, stream.bytesAvailable);
			stream.close();
			return bytes;
		}
		static public function write(bytes:ByteArray, file:File):void{
			const stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(bytes, 0, bytes.length);
			stream.close();
		}
		static public function writeString(data:String, file:File, charSet:String=""):void{
			const bytes:ByteArray = new ByteArray();
			if(charSet) bytes.writeMultiByte(data, charSet);
			else bytes.writeUTFBytes(data);
			write(bytes, file);
		}
		static public function fixExtension(file:File, extension:String, force:Boolean=true):File{
			if(file.extension!=extension && (!file.extension || force)){
				var name:String = file.name;
				file = file.parent.resolvePath(name+"."+extension);
			}
			return file;
		}
	}
}
