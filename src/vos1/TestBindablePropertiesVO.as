package vos1
{
	import commands.ICommand;

	[Bindable]
	public class TestBindablePropertiesVO
	{
		private var _property1Boolean:Boolean;
		private var _property1String:String;
		private var _property1Uint:uint;
		private var _property1ICommand:ICommand;
		public function TestBindablePropertiesVO()
		{
		}

		public function get property1ICommand():ICommand
		{
			return _property1ICommand;
		}

		public function set property1ICommand(value:ICommand):void
		{
			_property1ICommand = value;
		}

		public function get property1Uint():uint
		{
			return _property1Uint;
		}

		public function set property1Uint(value:uint):void
		{
			_property1Uint = value;
		}

		public function get property1String():String
		{
			return _property1String;
		}

		public function set property1String(value:String):void
		{
			_property1String = value;
		}

		public function get property1Boolean():Boolean
		{
			return _property1Boolean;
		}

		public function set property1Boolean(value:Boolean):void
		{
			_property1Boolean = value;
		}

	}
}