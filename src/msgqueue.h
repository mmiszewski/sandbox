/* $Id: msgqueue.h,v 1.6 2005-12-05 20:20:08 wojtekka Exp $ */

/*
 *  (C) Copyright 2001-2002 Piotr Domagalski <szalik@szalik.net>
 *                          Wojtek Kaniewski <wojtekka@irc.pl>
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

#ifndef __MSGQUEUE_H
#define __MSGQUEUE_H

#include <sys/types.h>
#include <time.h>

#include "dynstuff.h"
#include "libgadu.h"

struct msg_queue {
	int msg_class;
	int msg_seq;
	int uin_count;
	uin_t *uins;
	int secure;
	time_t time;
	unsigned char *msg;
	unsigned char *format;
	int formatlen;
};

list_t msg_queue;

int msg_queue_add(int msg_class, int msg_seq, int uin_count, uin_t *uins, const unsigned char *msg, int secure, const unsigned char *format, int formatlen);
int msg_queue_remove(int msg_seq);
int msg_queue_remove_uin(uin_t uin);
void msg_queue_free(void);
int msg_queue_flush(void);
int msg_queue_count(void);
int msg_queue_count_uin(uin_t uin);
int msg_queue_read(void);
int msg_queue_write(void);

int find_in_uins(int uin_count, uin_t *uins, uin_t uin);

#endif /* __MSGQUEUE_H */
