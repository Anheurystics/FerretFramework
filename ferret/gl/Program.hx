package ferret.gl;

import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;

class Program
{
	private var unit: GLProgram = GL.createProgram();
	
	private var uniformLocations: Map<String, GLUniformLocation> = new Map();
	private var attribLocations: Map<String, Int> = new Map();
	
	private var vertSource: String;
	private var fragSource: String;
	
	var version: Int = 
	#if (desktop || html5)
		#if linux
			130
		#else
			150
		#end
	#elseif mobile
		100
	#end;
	
	private function fixVertexSource(src: String): String
	{
		#if (desktop || mobile)
		src = "#version " + version + "\n" + src;
		#end
		
		src = StringTools.replace(src, "bgra", "rgba");
		
		return src;
	}
	
	private function fixFragmentSource(src: String): String
	{		
		#if (mobile || html5)
		src = "precision mediump float;\n" + src;
		src = StringTools.replace(src, "texture(", "texture2D(");
		#if html5
		src = StringTools.replace(src, "bgra", "rgba");
		#end
		#end
	
		#if (desktop || mobile)
		src = "#version " + version + "\n" + src;
		#end
		
		return src;
	}
	
	public function new(_vertSrc: String, _fragSrc: String) 
	{
		vertSource = fixVertexSource(_vertSrc);
		fragSource = fixFragmentSource(_fragSrc);
		
		var vertex: GLShader = GL.createShader(GL.VERTEX_SHADER);
		GL.shaderSource(vertex, vertSource);
		GL.compileShader(vertex);
		if (GL.getShaderParameter(vertex, GL.COMPILE_STATUS) != 1)
		{
			trace("VERTEX SHADER: " + GL.getShaderInfoLog(vertex));
		}

		var fragment: GLShader = GL.createShader(GL.FRAGMENT_SHADER);
		GL.shaderSource(fragment, fragSource);
		GL.compileShader(fragment);
		if (GL.getShaderParameter(fragment, GL.COMPILE_STATUS) != 1)
		{
			trace("FRAGMENT SHADER: " + GL.getShaderInfoLog(fragment));
		}
		
		GL.attachShader(unit, vertex);
		GL.attachShader(unit, fragment);
		GL.linkProgram(unit);
		if (GL.getProgramParameter(unit, GL.LINK_STATUS) != 1)
		{
			trace(GL.getProgramInfoLog(unit));
		}
		
		GL.deleteShader(vertex);
		GL.deleteShader(fragment);
	}
	
	public function uniform(name: String): GLUniformLocation
	{
		if (uniformLocations.exists(name)) return uniformLocations.get(name);
		var loc: GLUniformLocation = GL.getUniformLocation(unit, name);
		uniformLocations.set(name, loc);
		return loc;
	}
	
	public function attribLocation(name: String): Int
	{
		if (attribLocations.exists(name)) return attribLocations.get(name);
		var loc: Int = GL.getAttribLocation(unit, name);
		attribLocations.set(name, loc);
		return loc;		
	}
	
	public function bind(): Void
	{
		GL.useProgram(unit);
	}	
	
	public function unbind(): Void
	{
		GL.useProgram(null);
	}
}