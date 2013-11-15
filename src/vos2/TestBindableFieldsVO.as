package vos2
{
	import commands.ICommand;

	[Bindable]
	public class TestBindableFieldsVO extends Object
	{
		public var property2Boolean:Boolean;
		public var property2String:String;
		public var property2Uint:uint;
		public var property2ICommand:ICommand;
		public function TestBindableFieldsVO()
		{
			super();
		}
	}
}