
float remap(float value, vector a, vector b)
{
	return b.x + (value - a.x) * (b.y - b.x) / (a.y - a.x);
}
