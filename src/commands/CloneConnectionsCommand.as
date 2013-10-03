package commands{
	import content.CloneConnectionsPopUp;

	public class CloneConnectionsCommand extends AbstractCommand implements ICommandFactory{
		private var _temporary:Boolean;
		public function CloneConnectionsCommand(temp:Boolean=false):void{
			super(null);
			_temporary = temp;
		}
		public function getInstance():ICommand{
			return this;
		}
		override public function execute():void{
			CloneConnectionsPopUp.display(this._temporary);
		}
	}
}