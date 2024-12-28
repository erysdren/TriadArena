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

bool widget_button(string id, vector pos, vector size, string text)
{
	sui_push_frame(pos, size);

	vector color = sui_is_hovered(id) ? MENU_BUTTON + MENU_HIGHLIGHT * 0.1 : MENU_BUTTON;
	color = sui_is_held(id) ? MENU_BUTTON - MENU_DARKEN * 0.1 : color;
	sui_fill([0, 0], size, color, 0.6, 0);
	sui_border_box([0, 0], size, 1, MENU_BUTTON_BORDER, 0.4, 0);

	sui_set_align([SUI_ALIGN_CENTER, SUI_ALIGN_CENTER]);

	sui_text([0, 0], MENU_TEXT_SMALL, text, MENU_TEXT_1, 1, 0);

	sui_action_element([0, 0], size, id, sui_noop);
	sui_pop_frame();

	return sui_is_clicked(id);
}

void widget_maplist(string id, vector pos, vector size, __inout vector scrollofs)
{
	searchhandle sh = search_begin("data/*.rtc:*.rtc", SB_FULLPACKAGEPATH | SB_MULTISEARCH, FALSE);

	sui_fill(pos, size, MENU_BG_DARK, 0.75, 0);

	sui_list_view_begin(strcat(id, "scrl"), pos, size, [size.x - 6, 24], search_getsize(sh), scrollofs, [0, 6]);

	vector listitem_pos = [0, 0];

	for (float i = sui_list_item(listitem_pos); i > -1; i = sui_list_item(listitem_pos))
	{
		sui_push_frame(listitem_pos, [size.x - 6, 24]);
		widget_button(strcat(id, ftos(i)), [0, 0], [size.x - 6, 24], search_getfilename(sh, i));
		sui_pop_frame();
	}

	sui_list_view_end();

	search_end(sh);
}
