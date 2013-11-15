package vos2
{
	import commands.ICommand;

	[Bindable]
	public class TestBindablePropertiesVO
	{
		private var _property2Boolean:Boolean;
		private var _property2String:String;
		private var _property2Uint:uint;
		private var _property2ICommand:ICommand;
		public function TestBindablePropertiesVO()
		{
		}

		public function get property2ICommand():ICommand
		{
			return _property2ICommand;
		}

		public function set property2ICommand(value:ICommand):void
		{
			_property2ICommand = value;
		}

		public function get property2Uint():uint
		{
			return _property2Uint;
		}

		public function set property2Uint(value:uint):void
		{
			_property2Uint = value;
		}

		public function get property2String():String
		{
			return _property2String;
		}

		public function set property2String(value:String):void
		{
			_property2String = value;
		}

		public function get property2Boolean():Boolean
		{
			return _property2Boolean;
		}

		public function set property2Boolean(value:Boolean):void
		{
			_property2Boolean = value;
		}

	}
}