package org.flixel.plugin.leveluplabs;
import nme.filters.DropShadowFilter;
import nme.filters.GlowFilter;
import nme.text.AntiAliasType;
import org.flixel.FlxText;

/**
 * Simple extension to the basic text field class. Basically, 
 * this lets me stick drop-shadows on things :)
 * @author Lars Doucet
 */

class FlxTextX extends FlxText
{

	public var dropShadow(getDropShadow, setDropShadow):Bool;
	
	private var _dropShadow:Bool = false;
	
	public function new(X:Float, Y:Float, Width:Int, Text:String = null, EmbeddedFont:Bool = true)	
	{
		super(X, Y, Width, Text, EmbeddedFont);
	}
	
	public function getDropShadow():Bool {
		return _dropShadow;
	}
	
	public function setDropShadow(b:Bool):Bool{
		_dropShadow = b;
		if (b) {
			_textField.filters = 
			[new GlowFilter(_shadow,1, 2, 2, 2, 1, false, false),
			new DropShadowFilter(1, 45, _shadow,1,1, 1, 0.25)];
		}else {
			_textField.filters = [];
		}
		_regen = true;
		calcFrame();
		return _dropShadow;
	}	
	
	
}