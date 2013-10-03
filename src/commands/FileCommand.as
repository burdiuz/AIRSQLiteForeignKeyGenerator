package commands{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public /*abstract*/ class FileCommand extends AbstractCommand implements ICommandFactory{
		protected var _file:File;
		protected var _parent:File;
		public function FileCommand(completeHandler:Function=null, parent:File=null):void{
			super(completeHandler);
			_parent = parent;
			if(Object(this).constructor==FileCommand){
				throw new Error("FileCommand class cannot be instantiated.");
			}
		}
		public function getInstance():ICommand{
			return this;
		}
		public function get file():File{
			return this._file ? this._file.clone() : null;
		}
		protected function addFileListeners():void{
			const file:File = this._file;
			file.addEventListener(Event.SELECT, this.fileSelectHandler);
			file.addEventListener(Event.CANCEL, this.fileCancelHandler);
		}
		protected function removeFileListeners():void{
			const file:File = this._file;
			if(file){
				file.removeEventListener(Event.SELECT, this.fileSelectHandler);
				file.removeEventListener(Event.CANCEL, this.fileCancelHandler);
			}
		}
		override public function execute():void{
			this._errorOccured = false;
			this._error = null;
			if(!this._file) this.clear();
		}
		override public function clear():void{
			if(this._file){
				this.removeFileListeners();
			}
			this._file = this._parent ? this._parent.clone() : File.documentsDirectory;
			this.addFileListeners();
		}
		protected function fileSelectHandler(event:Event):void{
			this.removeFileListeners();
		}
		protected function fileCancelHandler(event:Event):void{
			
		}
	}
}