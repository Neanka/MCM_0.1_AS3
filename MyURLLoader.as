package
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MyURLLoader extends URLLoader
	{
		private var _url:String;

		public function MyURLLoader(request:URLRequest=null)
		{
			super(request);
		}

		override public function load(request:URLRequest):void
		{
			super.load(request);
			_url = request.url;
		}

		public function get url():String
		{
			return _url;
		}
	}
}