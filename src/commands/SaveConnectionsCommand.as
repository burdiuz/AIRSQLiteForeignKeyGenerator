package commands{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import aw.data.SQLConnectionConfiguration;
	import aw.file.FileUtils;
	
	public class SaveConnectionsCommand extends FileCommand{
		public function SaveConnectionsCommand(completeHandler:Function=null):void{
			super(completeHandler);
		}
		override public function execute():void{
			this._parent = File.documentsDirectory.resolvePath(SQLConnectionConfiguration.getFileName(this.resources.databases.source));
			super.execute();
			if(!this.resources.databases || !this.resources.databases.length) return;
			this._file.browseForSave("Select Database connections configuration destination");
		}
		override protected function fileSelectHandler(event:Event):void{
			super.fileSelectHandler(event);
			try{
				FileUtils.fixExtension(this._file, "foreignkeys");
				SQLConnectionConfiguration.save(this._file, this.resources.databases.source);
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