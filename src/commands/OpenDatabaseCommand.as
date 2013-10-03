package commands{
	import content.OpenDatabasePopUp;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class OpenDatabaseCommand extends FileCommand{
		public function OpenDatabaseCommand(completeHandler:Function=null):void{
			super(completeHandler, File.userDirectory);
		}
		override public function execute():void{
			super.execute();
			this._file.browseForOpen("Select Database file", this.settings.getFileFilters());
		}
		public function open(file:File, autoCompact:Boolean=false, pageSize:uint=1024, encryptionKey:ByteArray=null):Boolean{
			var success:Boolean;
			try{
				success = this.resources.load(this._file, false, autoCompact, pageSize, encryptionKey);
			}catch(error:IOError){
				Alert.show("Can't read file, it may be blocked by another application.", "Error reading file");
			}catch(error:SecurityError){
				Alert.show("Can't read file, verify if you have adequate permissions to open it.", "Error reading file");
			}catch(error:Error){
				//success = false;
			}
			this._error = error;
			this._errorOccured = !success;
			if(!success){
				Alert.show("Sorry, selected file cannot be processed.", "SQLite connection error");
			}
			return success;
		}
		override protected function fileSelectHandler(event:Event):void{
			super.fileSelectHandler(event);
			this.open(this._file);
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.clear();
		}
	}
}