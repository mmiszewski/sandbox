/* $Id: token.h,v 1.4 2006-04-11 10:41:51 gophi Exp $ */

/*
 *  (C) Copyright 2003 Adam Czerwi�ski <acze@acze.net>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License Version 2 as
 *  published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef __TOKEN_H
#define __TOKEN_H

#ifdef HAVE_LIBJPEG
const int token_char_height = 12; 
const char token_id_char[] = {"0123456789abcdef"};
const char token_id[][15] = {
"..###..",
".#...#.",
".#...#.",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
".#...#.",
".#...#.",
"..###..",

"..#",
"###",
"..#",
"..#",
"..#",
"..#",
"..#",
"..#",
"..#",
"..#",
"..#",
"..#",

"..###..",
".#...#.",
"#.....#",
"#.....#",
"......#",
".....#.",
"....#..",
"...#...",
"..#....",
".#.....",
"#......",
"#######",

"..###..",
".#...#.",
"#.....#",
"#.....#",
".....#.",
"..###..",
".....#.",
"......#",
"#.....#",
"#.....#",
".#...#.",
"..###..",

".....#.",
"....##.",
"....##.",
"...#.#.",
"..#..#.",
"..#..#.",
".#...#.",
"#....#.",
"#######",
".....#.",
".....#.",
".....#.",

"#######",
"#......",
"#......",
"#......",
"#.###..",
"##...#.",
"#.....#",
"......#",
"#.....#",
"#.....#",
".#...#.",
"..###..",

"..###..",
".#...#.",
"#.....#",
"#......",
"#.###..",
"##...#.",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
".#...#.",
"..###..",

"#######",
"......#",
"......#",
".....#.",
".....#.",
"....#..",
"....#..",
"....#..",
"...#...",
"...#...",
"...#...",
"...#...",

"..###..",
".#...#.",
"#.....#",
"#.....#",
".#...#.",
"..###..",
".#...#.",
"#.....#",
"#.....#",
"#.....#",
".#...#.",
"..###..",

"..###..",
".#...#.",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
".#...##",
"..###.#",
"......#",
"#.....#",
".#...#.",
"..###..",

"........",
"........",
"........",
".#####..",
"#.....#.",
"......#.",
"......#.",
".######.",
"#.....#.",
"#.....#.",
"#.....#.",
".#####.#",

"#......",
"#......",
"#......",
"#.###..",
"##...#.",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
"##...#.",
"#.###..",

".......",
".......",
".......",
"..###..",
".#...#.",
"#.....#",
"#......",
"#......",
"#......",
"#.....#",
".#...#.",
"..###..",

"......#",
"......#",
"......#",
"..###.#",
".#...##",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
"#.....#",
".#...##",
"..###.#",

".......",
".......",
".......",
"..###..",
".#...#.",
"#.....#",
"#.....#",
"#######",
"#......",
"#.....#",
".#...#.",
"..###..",

"...##",
"..#..",
"..#..",
"#####",
"..#..",
"..#..",
"..#..",
"..#..",
"..#..",
"..#..",
"..#..",
"..#.."};
#endif

#ifdef HAVE_LIBUNGIF

/* Wy��czone, bo teraz nie u�ywamy palety, ale je�li kto� wymy�li lepszy 
 * algorytm wy�wietlania obrazka (ten jest beznadziejnie prosty) to mo�e 
 * si� przyda�. */

#undef TOKEN_GIF_PAL	

struct token_t {
	size_t sx, sy;
#ifdef TOKEN_GIF_PAL
	size_t pal_sz;
	unsigned char *pal;
#endif
	unsigned char *data;
};
#endif

#endif /* __TOKEN_H */
