/**
 * Created with IntelliJ IDEA.
 * User: Oleg Galabura
 * Date: 28.01.13
 * Time: 13:35
 * To change this template use File | Settings | File Templates.
 */
package {
	import aw.data.ForeignKeyAction;
	import aw.data.ForeignKeyInfo;
	import aw.file.FileUtils;
	
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	[Bindable]
	public class Settings {
		static public const FILE_NAME:String = "settings.amf";
		static public const instance:Settings = new Settings();
		public var addionalSQLiteFileExtensions:Array = [];
		public var exportClassPackageName:String = "aw.utils.db";
		public var exportClassNameTemplate:String = "_FKTriggers_";
		public var onInsertErrorMessage:String = "Error: Insert on table \"$table\" violates foreign key constraint \"$fkey\"";
		public var onUpdateErrorMessage:String = "Error: Update on table \"$table\" violates foreign key constraint \"$fkey\"";
		public var onDeleteErrorMessage:String = "Error: Delete on table \"$table\" violates foreign key constraint \"$fkey\"";
		public var onUpdateRestrictedErrorMessage:String = "Error: Update on table \"$table\" is restricted by foreign key constraint \"$fkey\"";
		public var onDeleteRestrictedErrorMessage:String = "Error: Delete on table \"$table\" is restricted by foreign key constraint \"$fkey\"";
		public var tablesShowDBName:Boolean = true;
		public var sortTableColumns:Boolean = false;
		public var triggerNameScheme:String = "$name_$action";
		public var triggersShowDBName:Boolean = true;
		public var displayDatabaseFields:Boolean = false;
		public var saveConnectionsOnExit:Boolean = true;
		public function Settings():void{
			super();
			if(instance) throw new Error("Settings class cannot be instantiated, use static property \"instance\" instead.");
			readInternal(this);
		}
		public function getFileFilters():Array{
			var extensions:String = this.addionalSQLiteFileExtensions.join(";*.");
			if(extensions) extensions = "*."+extensions;
			return [new FileFilter("SQLite DataBase file", "*.db;*.sqlite;*.sqlite3"+extensions), new FileFilter("Any file", "*.*")];
		}
		public function getTriggerName(info:ForeignKeyInfo, action:String):String{
			var name:String = this.triggerNameScheme;
			name = name.replace("$name", info.name);
			name = name.replace("$rTable", info.referenceDatabase ? info.referenceDatabase+"."+info.referenceTable : info.referenceTable);
			name = name.replace("$rCols", ForeignKeyInfo.columnsToList(info.referenceColumns).join("_"));
			name = name.replace("$action", action);
			name = name.replace("$table", info.database ? info.database+"."+info.table : info.table);
			name = name.replace("$cols", ForeignKeyInfo.columnsToList(info.columns).join("_"));
			return name;
		}
		static public function read():void{
			readInternal(Settings.instance);
		}
		static private function readInternal(target:Settings):void{
			var file:File = File.applicationStorageDirectory.resolvePath(FILE_NAME);
			if(!file.exists || file.isDirectory) return;
			const bytes:ByteArray = FileUtils.read(file);
			bytes.position = 0;
			var object:Object = bytes.readObject();
			for(var property:String in object){
				if(property in target) target[property] = object[property];
			}
		}
		static public function write():void{
			var file:File = File.applicationStorageDirectory.resolvePath(FILE_NAME);
			if(file.exists) file.deleteFile();
			const bytes:ByteArray = new ByteArray();
			bytes.writeObject(instance);
			FileUtils.write(bytes, file);
		}
	}
}
