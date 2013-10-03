package commands{
	import aw.data.DatabaseInfo;
	
	import content.OpenDatabasePopUp;
	import content.SQLExecuteWindow;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class CreateDatabaseCommand extends FileCommand{
		public function CreateDatabaseCommand(completeHandler:Function=null):void{
			super(completeHandler, File.userDirectory.resolvePath("default.sqlite"));
		}
		override public function execute():void{
			super.execute();
			this._file.browseForSave("Select destination folder and file name for DataBase");
		}
		public function create(file:File, autoCompact:Boolean=false, pageSize:uint=1024, encryptionKey:ByteArray=null):Boolean{
			var success:Boolean;
			var wasError:Boolean;
			try{
				if(file.exists){
					file.deleteFile();
				}
				success = this.resources.load(file, true, autoCompact, pageSize, encryptionKey);
				if(success){
					SQLExecuteWindow.display(this.resources.databases.getItemAt(0) as DatabaseInfo);
				}else wasError = true;
			}catch(error:IOError){
				Alert.show("Can't read file, it may be blocked by another application.", "Error reading file");
			}catch(error:SecurityError){
				Alert.show("Can't read file, verify if you have adequate permissions to open it.", "Error reading file");
			}catch(error:Error){
				wasError = true;
			}
			this._error = error;
			this._errorOccured = wasError;
			if(wasError){
				Alert.show("Database was not created due to unexpected error.", "Error");
			}
			return success && !wasError;
		}
		override protected function fileSelectHandler(event:Event):void{
			super.fileSelectHandler(event);
			this.create(this._file);
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.clear();
		}
	}
}