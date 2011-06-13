/*
* Copyright 2009 Johannes Berg <johannes@xxxxxxxxxxxxxxxx>
*
* Permission to use, copy, modify, and/or distribute this software for any
* purpose with or without fee is hereby granted, provided that the above
* copyright notice and this permission notice appear in all copies.
*
* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
* ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*
*
* Compile simply with:
* cc -o netlatency netlatency.c
*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
int32_t v;
int fd;

if (argc != 2) {
fprintf(stderr, "Usage: %s <latency [us]>\n", argv[0]);
fprintf(stderr, "\n");
fprintf(stderr, " latency: the maximum tolerable network latency you\n");
fprintf(stderr, " are willing to put up with [in microseconds]\n");
fprintf(stderr, "\n");
fprintf(stderr, "This program will block until you hit Ctrl-C, at which point\n");
fprintf(stderr, "the file descriptor is closed and the latency requirement is\n");
fprintf(stderr, "unregistered again.\n");
return 2;
}

v = atoi(argv[1]);

printf("setting latency to %d.%.6d seconds\n", v/1000000, v % 1000000);

fd = open("/dev/network_latency", O_WRONLY);
if (fd < 0) {
perror("open /dev/network_latency");
return 1;
}
if (write(fd, &v, sizeof(v)) != sizeof(v)) {
perror("write to /dev/network_latency");
return 1;
}

while (1) sleep(10);

return 0;
}

