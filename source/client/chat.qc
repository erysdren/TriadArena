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

typedef struct chat_message {
	string msg;
	float time;
} chat_message_t;

static int CHAT_MAX_HISTORY = 32;
static float CHAT_HISTORY_TIME = 10;
static chat_message_t chat_messages[CHAT_MAX_HISTORY];
static var int num_chat_messages = 0;

void chat_add(string msg)
{
	chat_messages[num_chat_messages].time = cltime;
	chat_messages[num_chat_messages].msg = msg;
	num_chat_messages++;

	if (num_chat_messages >= CHAT_MAX_HISTORY - 1)
	{
		memcpy(&chat_messages[0], &chat_messages[1], (CHAT_MAX_HISTORY - 1) * sizeof(chat_message_t));
		num_chat_messages = CHAT_MAX_HISTORY - 2;
	}
}

void chat_draw(vector vsize)
{
	// start pos
	vector pos = [32, vsize.y - 64];

	// draw messages in reverse order
	for (int i = num_chat_messages - 1; i >= 0; i--)
	{
		if (pos.y < 0)
			break;

		if (cltime - chat_messages[i].time >= CHAT_HISTORY_TIME)
			continue;
		if (chat_messages[i].msg == "")
			continue;

		drawstring(pos, chat_messages[i].msg, [8, 8]);
		pos.y -= 8;
	}
}
