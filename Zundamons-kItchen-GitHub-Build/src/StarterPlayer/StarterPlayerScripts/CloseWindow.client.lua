-- [[LocalScript] CloseWindow (ref: RBX70660312D1E6409FB1DC72CD1FB3714D)]]
local button = script.Parent
local inv_frame = button.Parent

function close()
	inv_frame.Visible = false
end

button.MouseButton1Down:Connect(close)