using Godot;
using System;

public partial class MovingBlock : Sprite2D
{
	Vector2 direction = Vector2.Up;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Position += direction * ((float)delta) * 500.0f; 
		
		
		if (Position.Y > 500) {
			direction = Vector2.Up;
		}
		
		if (Position.Y < 0) {
			direction = Vector2.Down;
		}
	}
}
