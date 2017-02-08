package game.utils
{
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	public class Cookie
	{
		
		private var _time:uint;
		private var _name:String;
		private var _so:SharedObject;
		
		public function Cookie(name:String="data",timeOut:uint=int.MAX_VALUE)
		{
			_name = name;
			_time = timeOut;
			_so = SharedObject.getLocal(name,"/");
		}
		
		//Clear the timeout content;
		public function clearTimeOut():void
		{
			var obj:* = _so.data.cookie;
			if (obj == undefined)
			{
				return;
			}
			for (var key:* in obj)
			{
				if (obj[key] == undefined || obj[key].time == undefined || isTimeOut(obj[key].time))
				{
					delete obj[key];
				}
			}
			_so.data.cookie = obj;
			flush();
		}
		
		private function isTimeOut(time:uint):Boolean
		{
			var today:Date = new Date  ;
			return time + _time * 1000 < today.getTime();
		}
		
		//Get the timeout value;
		public function getTimeOut():uint
		{
			return _time;
		}
		
		//Get the name;
		public function getName():String
		{
			return _name;
		}
		
		//Clear all values ​​for cookies;
		public function clear():void
		{
			_so.clear();
		}
		
		//Add the cookie value  
		public function put(key:String,value: * ):void
		{
			var today:Date = new Date  ;
			key = "key_" + key;
			//value.time = today.getTime();
			if (_so.data.cookie == undefined)
			{
				var obj:Object = {};
				obj[key] = value;
				_so.data.cookie = obj;
			}
			else
			{
				_so.data.cookie[key] = value;
			}
			flush();
		}
		
		
		private function flush():void
		{
			if(_so){
				try{
					_so.flush();
				}catch(e:Error){
					Security.showSettings();
					Security.showSettings( SecurityPanel.LOCAL_STORAGE );
				}
			}
		}
		
		//Delete the cookie value;  
		public function remove(key:String):void
		{
			if (contains(key))
			{
				delete _so.data.cookie["key_" + key];
				flush();
			}
		}
		
		//Get the cookie value;  
		public function get(key:String):Object
		{
			return contains(key) ? _so.data.cookie["key_" + key]:null;
		}
		
		//Cookie value exists;  
		public function contains(key:String):Boolean
		{
			key = "key_" + key;
			return _so.data.cookie != undefined && _so.data.cookie[key] != undefined;
		}
	}
}