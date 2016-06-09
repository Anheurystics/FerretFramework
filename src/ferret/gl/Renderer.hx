package ferret.gl;

import ferret.gl.Mat;
import ferret.gl.Mat4;
import ferret.gl.Mesh;
import ferret.gl.Program;
import openfl.gl.GL;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.utils.Int32Array;

typedef Attrib =
{
	var name: String;
	var size: Int;
}

class Renderer
{
	public var program: Program;

	private var nVertices: Int;
	private var nIndices: Int;
	private var drawMode: Int;

	public function new() {}
	
	public function viewport(x: Int, y: Int, w: Int, h: Int): Void
	{
		GL.viewport(x, y, w, h);
	}

	public function depthTest(func: Int = null): Void
	{
		if (func != null)
		{
			GL.enable(GL.DEPTH_TEST);
			GL.depthFunc(func);
		}
		else
		{
			GL.disable(GL.DEPTH_TEST);
		}
	}

	public function blend(src: Int = null, dest: Int = null): Void
	{
		if (src != null && dest != null)
		{
			GL.enable(GL.BLEND);
			GL.blendFunc(src, dest);
		}
		else
		{
			GL.disable(GL.BLEND);
		}
	}

	public function clear(r: Float = 0.0, g: Float = 0.0, b: Float = 0.0)
	{
		GL.clearColor(r, g, b, 1.0);
		GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);
	}

	public function uploadProgram(program: Program)
	{
		this.program = program;
		program.bind();
	}

	public function uploadTexture(tex: Texture, unit: Int = GL.TEXTURE0)
	{
		GL.activeTexture(unit);
		GL.bindTexture(GL.TEXTURE_2D, tex.unit);
	}

	public function uploadMesh(mesh: Mesh): Void
	{
		nVertices = mesh.nVertices;
		nIndices = mesh.nIndices;
		drawMode = mesh.drawMode;
		
		GL.bindBuffer(GL.ARRAY_BUFFER, mesh.vertexBuffer);
		
		var off: Int = 0;
		for (i in 0...mesh.attribNames.length)
		{
			var loc: Int = program.attribLocation(mesh.attribNames[i]);
			if (loc != -1)
			{
				GL.vertexAttribPointer(loc, mesh.attribSizes[i], GL.FLOAT, false, mesh.totalAttribSize * Float32Array.BYTES_PER_ELEMENT, off * Float32Array.BYTES_PER_ELEMENT);
				GL.enableVertexAttribArray(loc);
			}
			
			off += mesh.attribSizes[i];
		}
		
		if (nIndices > 0)
		{
			GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, mesh.indexBuffer);
		}
	}

	public function setRenderTarget(target: RenderTarget): Void
	{
		if (target != null)
		{
			GL.bindFramebuffer(GL.FRAMEBUFFER, target.framebuffer);
		}
		else
		{
			GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		}
	}
	
	public function uploadRenderTexture(target: RenderTarget, unit: Int = GL.TEXTURE0)
	{
		GL.activeTexture(unit);
		GL.bindTexture(GL.TEXTURE_2D, target.texture);
	}
	
	private var identity = new Mat4();
	public function renderMesh(transform: Mat = null, offset: Int = 0): Void
	{
		if (transform == null)
		{
			transform = identity;
		}
		
		uniformMatrix("model", transform);
		uniformMatrix("normalModel", transform.clone().inverse().transpose());

		if (nIndices > 0)
		{
			GL.drawElements(drawMode, nIndices, GL.UNSIGNED_SHORT, offset);
		}
		else
		{
			GL.drawArrays(drawMode, offset, nVertices);
		}
	}

	public function uniformf(name: String, d1: Float, d2: Float = null, d3: Float = null, d4: Float = null)
	{
		var loc: GLUniformLocation = program.uniform(name);
		if (d2 == null) 		GL.uniform1f(loc, d1);
		else if (d3 == null) 	GL.uniform2f(loc, d1, d2);
		else if (d4 == null) 	GL.uniform3f(loc, d1, d2, d3);
		else 					GL.uniform4f(loc, d1, d2, d3, d4);
	}

	private var uniformFV: Array<GLUniformLocation->Float32Array->Void> = [GL.uniform1fv, GL.uniform2fv, GL.uniform3fv, GL.uniform4fv];
	public function uniformfv(name: String, arr: Float32Array)
	{
		var loc: GLUniformLocation = program.uniform(name);
		uniformFV[arr.length - 1](loc, arr);
	}

	private var uniformIV: Array<GLUniformLocation->Int32Array->Void> = [GL.uniform1iv, GL.uniform2iv, GL.uniform3iv, GL.uniform4iv];
	public function uniformiv(name: String, arr: Int32Array)
	{
		var loc: GLUniformLocation = program.uniform(name);
		uniformIV[arr.length - 1](loc, arr);
	}

	public function uniformi(name: String, d1: Int, d2: Int = null, d3: Int = null, d4: Int = null)
	{
		var loc: GLUniformLocation = program.uniform(name);
		if (d2 == null) 		GL.uniform1i(loc, d1);
		else if (d3 == null) 	GL.uniform2i(loc, d1, d2);
		else if (d4 == null) 	GL.uniform3i(loc, d1, d2, d3);
		else 					GL.uniform4i(loc, d1, d2, d3, d4);
	}

	public function uniformMatrix(name: String, mat: Mat): Void
	{
		GL.uniformMatrix4fv(program.uniform(name), false, mat.array());
	}
}