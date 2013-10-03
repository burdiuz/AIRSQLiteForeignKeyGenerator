package commands{
	import content.AttachDBPopUp;
	
	public class AttachDatabaseCommand extends AbstractCommand implements ICommandFactory{
		public function AttachDatabaseCommand():void{
			super(null);
		}
		public function getInstance():ICommand{
			return this;
		}
		override public function execute():void{
			AttachDBPopUp.display();
		}
	}
}