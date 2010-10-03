package com.swfwire.debugger.injected
{
	import com.swfwire.utils.ObjectUtil;
	import com.swfwire.utils.StringUtil;
	
	import flash.utils.getTimer;
	
	public class Logger
	{
		public static var logToTrace:Boolean = true;
		public static var logToOutput:Boolean = false;
		public static var showMethodEntry:Boolean = false;
		public static var showMethodExit:Boolean = false;
		public static var showTraceStatements:Boolean = true;
		public static var showArguments:Boolean = false;
		public static var showReturn:Boolean = false;
		
		public static var output:*;
		public static var buffer:String = '';
		
		private static var indent:int = 0;
		private static var startTimes:Array = [];
		
		public static function enterFrame():void
		{
			if(buffer)
			{
				if(logToTrace)
				{
					trace(buffer.substr(0, -1));
				}
				if(logToOutput && output)
				{
					/*
					var str:String = StringUtil.repeat('	', indent) + message;
					if(!(message is String))
					{
						str = ObjectUtil.objectToString(message, 1, 3, 100, 1000, '	');
					}
					*/
					output.text += buffer;
					var shouldScroll:Boolean = output.verticalScrollPosition == output.maxVerticalScrollPosition;
					if(shouldScroll)
					{
						output.validateNow();
						output.verticalScrollPosition = output.maxVerticalScrollPosition;
					}
				}
				buffer = '';
			}
		}
		
		public static function _log(message:*):void
		{
			var str:String = StringUtil.indent(message, StringUtil.repeat('	', indent));
			buffer += str + '\n';
		}
		

		public static function log(... args):void
		{
			if(showTraceStatements)
			{
				_log(args);
			}
		}
		
		public static function enterFunction(methodName:String = 'unk', caller:* = null, params:Object = null):void
		{
			if(showMethodEntry)
			{
				//var methodName2:String = new StackInfo(1).functionName;
				_log('> ' + methodName);
			}
			indent++;
			if(showArguments && params)
			{
				_log(ObjectUtil.objectToString(params, 2, 2, 50, 50, '	'));
			}
			startTimes.push(getTimer());
			//_log('>>');
			return;
			if(showMethodEntry)
			{
				var methodName2:String = new StackInfo(1).functionName;
				_log('> ' + methodName2);
			}
			indent++;
			return;
			//log(caller);
			if(dumpArguments && params)
			{
				_log(ObjectUtil.objectToString(params, 2, 2, 50, 50, '	'));
			}
		}
		
		public static function exitFunction(methodName:String = 'unk', returnValue:* = null):void
		{
			if(showReturn && returnValue)
			{
				_log('return '+ObjectUtil.objectToString(returnValue, 2, 2, 50, 50, '	'));
			}
			indent--;
			//indent = Math.max(indent, 0);
			
			var start:int = startTimes.pop();
			
			if(showMethodEntry && showMethodExit)
			{
				//var methodName2:String = new StackInfo(1).functionName;
				//_log('<< ' + methodName2);

				_log('< '+(getTimer() - start)+'ms');
				
				//_log('<<');
			}
			return;
		}
		
		public static function uncaughtError(e:* = null):void
		{
			indent = 0;
			startTimes = [];
			
			_log('Uncaught error:');
			_log(ObjectUtil.objectToString(e, 2, 2, 50, 50, '	'));
		}
	}
}