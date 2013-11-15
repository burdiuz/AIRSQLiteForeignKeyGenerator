package vos1
{
	import commands.ICommand;

	[Bindable]
	public class TestBindableFieldsVO
	{
		public var property1Boolean:Boolean;
		public var property1String:String;
		public var property1Uint:uint;
		public var property1ICommand:ICommand;
		public function TestBindableFieldsVO()
		{
			super();
		}
	}
}