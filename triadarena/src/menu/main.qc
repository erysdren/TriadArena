/*
Copyright (C) 1994-1995 Apogee Software, Ltd.
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

static bool menu_active;

void m_open(void)
{
	setkeydest(2);
	menu_active = true;
}

void m_close(void)
{
	setkeydest(0);
	menu_active = false;
}

void m_toggle(float wantmode)
{
	if (wantmode)
		m_open();
	else
		m_close();
}

void m_init(void)
{
	setwindowcaption("Triad Arena");
}

void m_shutdown(void)
{

}

void m_drawloading(vector screensize, float opaque)
{
	sui_begin(screensize.x, screensize.y);
	sui_fill([0, 0], screensize, [0, 0, 0], 1, DRAWFLAG_NORMAL);
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
	sui_text([0, 0], [8, 8], "LOADING...", [1, 1, 1], 1, DRAWFLAG_NORMAL);
	sui_end();
}

void m_draw(vector screensize)
{
	if (!menu_active)
		return;

	sui_begin(screensize.x, screensize.y);
	sui_fill([0, 0], screensize, [0, 0, 0], 0.5, DRAWFLAG_NORMAL);
	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);
	widget_button("m_main_start", [0, 0], [128, 32], "START") ? localcmd("map darkwar.rtc_0.map\n") : 0;
	sui_end();
}

float m_consolecommand(string cmd)
{
	return FALSE;
}

float Menu_InputEvent(float evtype, float scanx, float chary, float devid)
{
	switch (evtype)
	{
		case IE_KEYDOWN:
		{
			switch (getkeybind(scanx))
			{
				case "togglemenu":
				{
					if (menu_active)
						m_close();
					else
						m_open();
					return TRUE;
				}

				case "toggleconsole":
				{
					localcmd("toggleconsole\n");
					return TRUE;
				}

				default:
				{
					break;
				}
			}

			break;
		}
	}

	return sui_input_event(evtype, scanx, chary, devid);
}
