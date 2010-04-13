#include <mega32.h>
void ByteReverse(unsigned long* pul){
    unsigned char uc;

    uc = *((unsigned char*)pul + 0);                                // msb
    *((unsigned char*)pul + 0) = *((unsigned char*)pul + 3);        // lsb
    *((unsigned char*)pul + 3) = uc;

    uc = *((unsigned char*)(pul) + 1);                                // msb
    *((unsigned char*)pul + 1) = *((unsigned char*)pul + 2);        // lsb
    *((unsigned char*)pul + 2) = uc;
}

unsigned char Sum(unsigned char* pucBuffer, unsigned char ucLength){
    unsigned char    uc,
                    ucSum = 0x00;

    for(uc = 0; uc < ucLength; uc++){
        ucSum += pucBuffer[uc];
    }

    return ucSum;
}