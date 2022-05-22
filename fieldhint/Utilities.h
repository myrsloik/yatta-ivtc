/*
 * Utilities.h
 * from Decomb 5.2.1 by Donald Graft
 */

bool PutHintingData(unsigned char *video, unsigned int hint);
bool GetHintingData(unsigned char *video, unsigned int *hint);
bool RemoveHintingData(unsigned char *video);

#define HINT_INVALID 0x80000000
#define PROGRESSIVE  0x00000001
#define IN_PATTERN   0x00000002
