package aw.data{
	import mx.collections.ArrayList;
	
	public class ForeignKeyAction extends Object{
		static private var _noAction:ForeignKeyAction;
		static public function get NO_ACTION():ForeignKeyAction{
			if(!_noAction) _noAction = new ForeignKeyNoAction();
			return _noAction;
		}
		static private var _restrict:ForeignKeyAction;
		static public function get RESTRICT():ForeignKeyAction{
			if(!_restrict) _restrict = new ForeignKeyRestrictAction();
			return _restrict;
		}
		static private var _cascade:ForeignKeyAction;
		static public function get CASCADE():ForeignKeyAction{
			if(!_cascade) _cascade = new ForeignKeyCascadeAction();
			return _cascade;
		}
		static private var _setNull:ForeignKeyAction;
		static public function get SET_NULL():ForeignKeyAction{
			if(!_setNull) _setNull = new ForeignKeySetNULLAction();
			return _setNull;
		}
		static private var _setDefault:ForeignKeyAction;
		static public function get SET_DEFAULT():ForeignKeyAction{
			if(!_setDefault) _setDefault = new ForeignKeySetDefaultAction();
			return _setDefault;
		}
		static private const _strings:Object = {
			"0": "NO ACTION", 
			"1": "RESTRICT", 
			"2": "CASCADE", 
			"4": "SET NULL", 
			"5": "SET DEFAULT" 
		};
		private var _value:int;
		public function ForeignKeyAction(value:ForeignKeyActionValue):void{
			super();
			_value = value.value;
		}
		public function get value():int{
			return this._value;
		}
		public function get label():String{
			return getLabel(this._value);
		}
		public function toString():String{
			return getLabel(this._value);
		}
		public function valueOf():Object{
			return this._value;
		}
		static public function getByValue(value:int):ForeignKeyAction{
			var action:ForeignKeyAction;
			switch(value){
				case 0:
					action = NO_ACTION;
					break;
				case 1:
					action = RESTRICT;
					break;
				case 2:
					action = CASCADE;
					break;
				case 4:
					action = SET_NULL;
					break;
				case 5:
					action = SET_DEFAULT;
					break;
			}
			return action;
		}
		static public function getLabel(value:int):String{
			return value in _strings ? _strings[value] : null;
		}
		static public function getList():Array{
			return [NO_ACTION, RESTRICT, CASCADE, SET_NULL, SET_DEFAULT];
		}
		static public function getArrayList():ArrayList{
			return new ArrayList(getList());
		}
	}
}

import aw.data.ForeignKeyAction;

import flash.net.registerClassAlias;

class ForeignKeyActionValue{
	public var value:int;
	public function ForeignKeyActionValue(value:int):void{
		super();
		this.value = value;
	}
}

class ForeignKeyNoAction extends ForeignKeyAction{
	public function ForeignKeyNoAction():void{
		super(new ForeignKeyActionValue(0));
	}
	registerClassAlias("ForeignKeyNoAction", ForeignKeyNoAction);
}

class ForeignKeyCascadeAction extends ForeignKeyAction{
	public function ForeignKeyCascadeAction():void{
		super(new ForeignKeyActionValue(2));
	}
	registerClassAlias("ForeignKeyCascadeAction", ForeignKeyCascadeAction);
}

class ForeignKeyRestrictAction extends ForeignKeyAction{
	public function ForeignKeyRestrictAction():void{
		super(new ForeignKeyActionValue(1));
	}
	registerClassAlias("ForeignKeyRestrictAction", ForeignKeyRestrictAction);
}

class ForeignKeySetNULLAction extends ForeignKeyAction{
	public function ForeignKeySetNULLAction():void{
		super(new ForeignKeyActionValue(4));
	}
	registerClassAlias("ForeignKeySetNULLAction", ForeignKeySetNULLAction);
}

class ForeignKeySetDefaultAction extends ForeignKeyAction{
	public function ForeignKeySetDefaultAction():void{
		super(new ForeignKeyActionValue(5));
	}
	registerClassAlias("ForeignKeySetDefaultAction", ForeignKeySetDefaultAction);
}