package commands{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import aw.data.ForeignKeyInfo;
	
	public class LoadForeignKeysCommand extends FileCommand{
		private var _application:SQLiteForeignKeyGenerator;
		public function LoadForeignKeysCommand(application:SQLiteForeignKeyGenerator, completeHandler:Function=null):void{
			super(completeHandler, File.documentsDirectory);
			_application = application;
		}
		override public function execute():void{
			super.execute();
			this._file.browseForOpen("Select Foreign Keys file", [new FileFilter("Foreign Keys file", "*.foreignkeys")]);
		}
		override protected function fileSelectHandler(event:Event):void{
			super.fileSelectHandler(event);
			try{
				const list:Array = ForeignKeyInfo.load(this._file);
				if(this._application.list){
					this._application.list.addAll(new ArrayList(list));
				}else{
					this._application.list = new ArrayList(list);
				}
			}catch(error:IOError){
				Alert.show("Can't write file, verify if you have adequate permissions to save it.", "Error writing file");
			}catch(error:Error){
				Alert.show("Unexpected error occured while processing this file.", "Error processing file");
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.clear();
		}
	}
}