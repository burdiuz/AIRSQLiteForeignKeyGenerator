package aw.data{
	import commands.ICommand;
	import commands.ICommandFactory;
	
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	public class NMItem extends NativeMenuItem{
		private var _enablingChangeWatcher:ChangeWatcher;
		private var _commandFactory:ICommandFactory;
		private var _hasDisablingValue:Boolean;
		public function NMItem(label:String="", handler:*=null, keyEquivalent:String="", keyEquivalentModifiers:Array=null, enablingHost:Object=null, enablingChain:Array=null, hasDisablingValue:Boolean=false):void{
			super(label, false);
			_hasDisablingValue = hasDisablingValue;
			this.keyEquivalent = keyEquivalent;
			if(keyEquivalentModifiers){
				this.keyEquivalentModifiers = keyEquivalentModifiers;
			}
			if(enablingHost && enablingChain){
				this._enablingChangeWatcher = BindingUtils.bindSetter(this.enabledMutatorHandler, enablingHost, enablingChain);
			}
			if(handler is ICommandFactory){
				_commandFactory = handler;
				addEventListener(Event.SELECT, this.selectHandler);
			}else if(handler is Function){
				addEventListener(Event.SELECT, handler);
			}
		}
		public function get commandFactory():ICommandFactory{
			return this._commandFactory;
		}
		private function selectHandler(event:Event):void{
			const command:ICommand = this._commandFactory.getInstance();
			if(command){
				command.execute();
			}
		}
		private function enabledMutatorHandler(value:*):void{
			value = Boolean(value);
			this.enabled = this._hasDisablingValue ? !value : value;
		}
	}
}