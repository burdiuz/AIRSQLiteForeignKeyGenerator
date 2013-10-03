package commands{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import aw.data.ForeignKeyInfo;
	
	public class SaveForeignKeysCommand extends FileCommand{
		private var _application:SQLiteForeignKeyGenerator;
		public function SaveForeignKeysCommand(application:SQLiteForeignKeyGenerator, completeHandler:Function=null):void{
			super(completeHandler, File.documentsDirectory.resolvePath("default.foreignkeys"));
			_application = application;
		}
		override public function execute():void{
			if(!this._application.list || !this._application.list.length) return;
			super.execute();
			this._file.browseForSave("Select Foreign Keys file destination");
		}
		override protected function fileSelectHandler(event:Event):void{
			super.fileSelectHandler(event);
			const list:Array = this._application.list.source;
			try{
				ForeignKeyInfo.save(this._file, list);
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