/*
Copyright (C) 1994-1995 Apogee Software, Ltd.
Copyright (C) 1996-1997 Id Software, Inc.
Copyright (C) 2023-2025 erysdren (it/its)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

float remap(float value, vector a, vector b)
{
	return b.x + (value - a.x) * (b.y - b.x) / (a.y - a.x);
}

string strdup(string s)
{
	return sprintf("%s", s);
}

__variant *memrealloc(__variant *ptr, int oldsize, int newsize)
{
	if (!newsize)
	{
		memfree(ptr);
		return __NULL__;
	}
	else if (!ptr)
	{
		return memalloc(newsize);
	}
	else
	{
		void *ret = memalloc(newsize);
		memcpy(ret, ptr, oldsize > newsize ? newsize : oldsize);
		memfree(ptr);
		return ret;
	}
}
