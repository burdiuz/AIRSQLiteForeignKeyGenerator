package aw.data{
	import avmplus.getQualifiedClassName;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IPropertyChangeNotifier;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;

	[Event(name="collectionChange", type="mx.events.CollectionEvent")]
	[RemoteClass(alias="flex.messaging.io.FilteredArrayList")]
	[DefaultProperty("source")]
	
	public dynamic class FilteredArrayList extends Proxy implements IEventDispatcher, IList, IPropertyChangeNotifier, IExternalizable{
		private var _filtered:Object = {};
		private var _filterField:String;
		private var _list:ArrayList;
		private var _dispatcher:IEventDispatcher;
		public function FilteredArrayList(filterField:String, source:*=null):void{
			super();
			_dispatcher = new EventDispatcher(this);
			_filterField = filterField;
			setSource(source);
		}
		override flash_proxy function getProperty(name:*):*{
			name = String(name);
			if(!(name in this._filtered)){
				const array:Array = filter(name);
				this._filtered[name] = array.length ? new ArrayList(array) : null;
			}
			return this._filtered[name];
		}
		private function filter(name:String):Array{
			const field:String = this._filterField;
			const source:Array = this._list.source;
			const array:Array = [];
			for each(var item:* in source){
				if(item && field in item && item[field] == name){
					array.push(item);
				}
			}
			return array;
		}
		override flash_proxy function callProperty(name:*, ...parameters):*{
			return this.flash_proxy::getProperty(name);
		}
		override flash_proxy function hasProperty(name:*):Boolean{
			if(!(name in this._filtered)){
				const array:Array = filter(name);
				this._filtered[name] = array.length ? new ArrayList(array) : null;
			}
			return Boolean(this._filtered[name]);
		}
		private function setSource(source:*):void{
			var array:Array;
			if(source is Array) array = source;
			else if(source is ArrayList) array = (source as ArrayList).source;
			else{
				array = [];
				if(source){
					for each(var item:* in source) array.push(item);
				}
			}
			this._list = new RemoteDispatcherArrayList(this._dispatcher, array);
			this._list.addEventListener(CollectionEvent.COLLECTION_CHANGE, this._dispatcher.dispatchEvent);
			this._list.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._dispatcher.dispatchEvent);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			this._dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			this._dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean{
			return this._dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean{
			return this._dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean{
			return this._dispatcher.willTrigger(type);
		}
		
		[Bindable("collectionChange")]
		public function get length():int
		{
			return this._list.length;
		}
		public function get source():Array
		{
			return this._list.source;
		}
		public function set source(value:Array):void
		{
			this._list.source = value;
		}
		
		public function addItem(item:Object):void
		{
			this._list.addItem(item);
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			this._list.addItemAt(item, index);
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			return this._list.getItemAt(index, prefetch);
		}
		
		public function getItemIndex(item:Object):int
		{
			return this._list.getItemIndex(item);
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
			this._list.itemUpdated(item, property, oldValue, newValue);
		}
		
		public function removeAll():void
		{
			this._list.removeAll();
		}
		
		public function removeItemAt(index:int):Object
		{
			return this._list.removeItemAt(index);
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			return this._list.setItemAt(item, index);
		}
		
		public function toArray():Array
		{
			return this._list.toArray();
		}
		
		public function get uid():String
		{
			return this._list.uid;
		}
		
		public function set uid(value:String):void
		{
			this._list.uid = value;
		}
		
		public function writeExternal(output:IDataOutput):void
		{
			this._list.writeExternal(output);
		}
		
		public function readExternal(input:IDataInput):void
		{
			this._list.readExternal(input);
		}
	}
}
import flash.events.IEventDispatcher;

import mx.collections.ArrayList;

class RemoteDispatcherArrayList extends ArrayList{
	private var _remoteDispatcher:IEventDispatcher
	public function RemoteDispatcherArrayList(dispatcher:IEventDispatcher, source:Array=null):void{
		super(source);
		_remoteDispatcher = dispatcher;
	}
	public function get remoteDispatcher():IEventDispatcher{
		return this._remoteDispatcher;
	}
	override public function hasEventListener(type:String):Boolean{
		return this._remoteDispatcher.hasEventListener(type);
	}
	override public function willTrigger(type:String):Boolean{
		return this._remoteDispatcher.willTrigger(type);
	}
}