package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class CalloutScreen extends PanelScreen
	{
		public static const CHILD_STYLE_NAME_CALLOUT_HEADER:String = "components-explorer-callout-header";

		public static var globalStyleProvider:IStyleProvider;

		public function CalloutScreen()
		{
			super();
		}

		private var _showCalloutButton:Button;
		private var _content:PanelScreen;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return CalloutScreen.globalStyleProvider;
		}

		override public function dispose():void
		{
			//the content won't be on the display list when the screen is
			//disposed, so dispose it manually
			if(this._content)
			{
				this._content.dispose();
				this._content = null;
			}
			super.dispose();
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Callout";

			//this is what we're going to display in the callout
			this._content = new PanelScreen();
			this._content.customHeaderStyleName = CHILD_STYLE_NAME_CALLOUT_HEADER;
			this._content.title = "Callout Content";
			this._content.width = 200;
			this._content.layout = new AnchorLayout();
			var description:Label = new Label();
			description.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			description.wordWrap = true;
			description.text = "A callout displays content in a pop-up container, with an arrow that points to its origin.\n\nTap anywhere outside of the callout to close it.";
			this._content.addChild(description);
			//the content will be shown in the callout, so we don't add it to a
			//parent yet.

			this._showCalloutButton = new Button();
			this._showCalloutButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON);
			this._showCalloutButton.label = "Show Callout";
			this._showCalloutButton.addEventListener(Event.TRIGGERED, showCalloutButton_triggeredHandler);
			this.addChild(this._showCalloutButton);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			return header;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function showCalloutButton_triggeredHandler(event:Event):void
		{
			var callout:Callout = Callout.show(this._content, this._showCalloutButton);
			//we're reusing the content every time that it is shown, so we don't
			//want the content to be disposed. we'll dispose of it manually
			//later when the screen is disposed.
			callout.disposeContent = false;
		}
	}
}
