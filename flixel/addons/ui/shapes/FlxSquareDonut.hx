package flixel.addons.ui.shapes;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;

/**
 * ...
 * @author Lars A. Doucet
 */class FlxSquareDonut extends FlxShape {

	var radius_out : Float;
	var radius_in : Float;
	var erase : Shape;
	var canvas : BitmapData;
	var draw_rect : Rectangle;
	var draw_point : Point;
	var line_alpha : Float;
	var fill_alpha : Float;
	public function new(p : Point, r1 : Float, r2 : Float, st : Float, sc : Int, la : Float = 1, fill : Bool = false, fc : Int = 0xFFFFFF, fa : Float = 1) {
		shape_id = "square_donut";
		radius_out = r1;		
		radius_in = r2;
		erase = new Shape();
		line_alpha = la;
		fill_alpha = fa;
		if(radius_out <= 0) 
			radius_out = 1;
		super(st, sc, fill, fc, p.x, p.y, radius_out, radius_out);
		canvas = new BitmapData(radius_out * 2, radius_out * 2, true, 0x000000FF);
		draw_rect = new Rectangle(0, 0, radius_out * 2, radius_out * 2);
		draw_point = new Point(x - radius_out, y - radius_out);
		buffer();
	}

	public function setRadii(r1 : Float, r2 : Float) : Void {
		radius_out = r1;
		radius_in = r2;
		buffer();
	}

	override public function buffer() : Void {
		var r : Float;
		var pos : Float;
		drawShape.graphics.clear();
		drawShape.graphics.lineStyle(stroke_thick, stroke_col, line_alpha);
		if(has_fill)  {
			drawShape.graphics.beginFill(fill_col, fill_alpha);
		}
		//drawShape.graphics.drawCircle(radius_out, radius_out, radius_out-(stroke_thick/2));
		r = (radius_out * 2) - stroke_thick;
		drawShape.graphics.drawRect(stroke_thick / 2, stroke_thick / 2, r, r);
		if(has_fill)  {
			drawShape.graphics.endFill();
		}
		erase.graphics.clear();
		if(radius_in > 0)  {
			pos = radius_out - radius_in;
			r = (radius_in * 2);
			//drawShape.graphics.drawCircle(radius_out, radius_out, radius_in+(stroke_thick/2));
			drawShape.graphics.drawRect(pos - (stroke_thick / 2), pos - (stroke_thick / 2), r + (stroke_thick), r + (stroke_thick));
			erase.graphics.beginFill(0x000000, 1);
			//erase.graphics.drawCircle(radius_out, radius_out, radius_in);
			erase.graphics.drawRect(pos, pos, r, r);
			erase.graphics.endFill();
		}
		draw_point.x = x - radius_out;
		draw_point.y = y - radius_out;
		canvas.fillRect(draw_rect, 0x00000000);
		canvas.draw(drawShape);
		canvas.draw(erase, null, null, "erase", null, true);
	}

	override public function render() : Void {
		getScreenXY(_point);
		_flashPoint.x = _point.x;
		_flashPoint.y = _point.y;
		var m : Matrix = new Matrix();
		m.identity();
		m.transformPoint(_flashPoint);
		var c : ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, (-255 + (256 * alpha)));
		FlxG.buffer.copyPixels(canvas, draw_rect, draw_point, null, null, true);
	}

}

