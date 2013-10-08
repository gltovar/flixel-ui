package flixel.addons.ui;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flixel.text.FlxText;

import EReg;
import StringTools;
/**
 * Simple extension to the basic text field class. Basically, 
 * this lets me stick drop-shadows on things :)
 * @author Lars Doucet
 */

class FlxUIText extends FlxText implements IResizable implements IFlxUIWidget 
{
	static inline var SIZE_FIT_CHARACTER_MINIMUM = 4;
	static inline var SIZE_FIT_WIDTH_BUFFER:Int = 4;
	static inline var SIZE_FIT_HEIGHT_BUFFER:Int = 4;
	static inline var SIZE_FIT_SIZE_DECREMENT_INTERVAL:Int = 1;
	static inline var SIZE_FIT_MAX_TRIES:Int = 100;

	/**
	*	Make a wordWrapped == false textfield fit with in a defined width
	*	@param TargetUIText:FlxUIText  the FlxUIText to be adjusted
	*	@param WidthToFit:Float  The width you'd like the textfield to be
	*	@param MinimumFontSize:Int  The smallest you ever want to text to be. default 6
	*/
	private static function fontSizeToFitWidth( TargetUIText:FlxUIText, WidthToFit:Float, MinimumFontSize:Int = 6 ):Void
	{
		if( TargetUIText.wordWrap == true )
		{
			throw "Text must not have word wrap enabled to size it to width";
		}

		var center:Float = TargetUIText.y + 0.5 *  TargetUIText.getTextField().height;

		var numTries:Float = 0;
		while(TargetUIText.getTextField().textWidth + SIZE_FIT_WIDTH_BUFFER > WidthToFit && TargetUIText.size > SIZE_FIT_CHARACTER_MINIMUM && numTries < SIZE_FIT_MAX_TRIES && TargetUIText.size >= MinimumFontSize )
		{
			TargetUIText.size -= SIZE_FIT_SIZE_DECREMENT_INTERVAL; // maybe this can be a binary search tree?
			numTries++;
		}
	
		TargetUIText.getTextField().height = TargetUIText.getTextField().textHeight + SIZE_FIT_HEIGHT_BUFFER;	
	}

	/**
	*	Make a wordWrapped == true textfield fit with in a defined height
	*	@param TargetUIText:FlxUIText  the FlxUIText to be adjusted
	*	@param HeightToFit:Float  The height you'd like the textfield to be
	*	@param MinimumFontSize:Int  The smallest you ever want to text to be. default 6
	*/
	private static function fontSizeToFitHeight(TargetUIText:FlxUIText, HeightToFit:Float, MinimumFontSize:Int = 6):Void
	{
		if( TargetUIText.wordWrap == false )
		{
			throw "Text must have word wrap enabled to size it to height";
		}

		var angle:Float = TargetUIText.angle;

		var separatorRegEx:EReg = ~/[-\s\t\r\n]/g;
		var originalText:String = StringTools.trim(TargetUIText.text);
		var wordChunks:Array<String> = new Array<String>();
		var wordAmount:Int = 1;

		if( originalText.length > 0 && separatorRegEx.match(originalText) == true )
		{
			wordChunks = separatorRegEx.split(originalText);
			wordAmount = wordChunks.length;

			// not count empty strings as a word
			for( k in 0...wordChunks.length )
			{
				if( wordChunks[k] == "" && wordAmount > 1 )
				{
					wordAmount--;
				}
			}
		}

		// make sure the longest word can fit on a single line
		if(wordAmount > 1)
		{
			var longestWord:String = "";
			for(i in 0...wordChunks.length)
			{
				var targetWord:String = wordChunks[i];
				if( targetWord.length > longestWord.length )
				{
					longestWord = targetWord;
				}
			}

			TargetUIText.text = longestWord;

			while( TargetUIText.getTextField().numLines > 1 && TargetUIText.size > MinimumFontSize )
			{
				TargetUIText.size -= SIZE_FIT_SIZE_DECREMENT_INTERVAL;
			}

			TargetUIText.text = originalText;
		}

		// fit text to desired height
		while( ( ( TargetUIText.getTextField().textHeight + SIZE_FIT_HEIGHT_BUFFER > HeightToFit) || ( wordAmount < TargetUIText.getTextField().numLines) ) && (TargetUIText.size > MinimumFontSize) )
		{
			TargetUIText.size -= SIZE_FIT_SIZE_DECREMENT_INTERVAL;
		}

		// set final height values of text field and flx text
		if( TargetUIText.getTextField().textHeight + SIZE_FIT_HEIGHT_BUFFER < HeightToFit)
		{
			TargetUIText.height = TargetUIText.getTextField().height = TargetUIText.getTextField().textHeight + SIZE_FIT_HEIGHT_BUFFER;
		}
	}


	public var id:String; 
	
	public var dropShadow(get, set):Bool;	
	private var _dropShadow:Bool = false;
	
	public function new(X:Float, Y:Float, Width:Int, Text:String = null, size:Int=8, EmbeddedFont:Bool = true)	
	{
		super(X, Y, Width, Text, size, EmbeddedFont);
	}

	public function fitToWidth():Void
	{
		this.wordWrap = false;
		fontSizeToFitWidth(this, this.width);
	}

	public function fitToHeight( DesiredHeight:Float ):Void
	{
		this.wordWrap = true;
		fontSizeToFitHeight(this, DesiredHeight);
	}
	
	public function resize(w:Float, h:Float):Void {
		width = w;
		height = h;
		calcFrame();
	}
		
	//For IResizable:
	public function get_width():Float {
		return width;
	}	
	public function get_height():Float {
		return height;
	}
	
	public function textWidth():Float {	return _textField.textWidth; }
	public function textHeight():Float { return _textField.textHeight; }
	
	public function get_dropShadow():Bool {
		return _dropShadow;
	}
	
	public function forceCalcFrame():Void {
		_regen = true;
		calcFrame();
	}
	
	public function set_dropShadow(b:Bool):Bool {
		_dropShadow = b;
		
		if (_dropShadow) 
		{
			//TODO: add these back in later:
			//addFilter(new GlowFilter(_shadow, 1, 2, 2, 2, 1, false, false));
			//addFilter(new DropShadowFilter(1, 45, _shadow, 1, 1, 1, 0.25));
		} 
		else
		{
			//removeAllFilters();
		}
		
		return _dropShadow;
	}	
		
	
	public function getTextField()
	{
		return _textField;
	}
	
}
