#include <stdio.h>

/* DEFINES */ 
typedef uint8_t bool;
#define true 1 
#define false 0

/* STRUCTS */ 
typedef struct 
{
  uint8_t BootJumpInstruction[3];
  uint8_t OemIdentifier[8];
  uint16_t BytesPerSector;
  uint8_t SectorsPerCluster;
  uint16_t ReservedSectors;
  uint8_t FatCount;
  uint16_t DirEntriesCount;
  uint16_t TotalSectors;
  uint8_t MediaDescriptorsType;
  uint16_t SectorsPerFat;
  uint16_t SectorsPerTrack;
  uint16_t Heads;
  uint32_t HiddenSectors;
  uint32_t LargeSectorCount;

  // exteneded boot record
  uint8_t DriveNumber;
  uint8_t _Reserved;
  uint8_t Signature;
  uint8_t VolumeId;                 // serial number, value doesn't matter
  uint8_t VolumeLabel[11];          // 11 bytes, padded with spaces
  uint8_t SystemId[8];
} __attribute__((packed)) BootSector;

/* GLOBAL VARIABLES */ 
BootSector g_BootSector
uint8_t* g_Fat = NULL;

/* FUNCTIONS */
/**
 * Reads data from the boot sector
 * 
 * @param *disk pointer to disk
 * @return boolean, false for error
 */
bool readBootSector(FILE* disk)
{
  return fread(&g_BootSector, sizeof(g_BootSector), 1, disk) > 0;
}

/**
 * Reads data from a specifiied sector
 * 
 * @param *disk pointer to disk
 * @return boolean, false for error
 */
bool readSectors(FILE* disk, uint32_t lba, uint32_t count, void* bufferOut)
{
  bool ok = true;
  ok = ok && (fseek(disk, lba * g_BootSector.BytesPerSector, SEEK_SET == 0);
  ok = ok && (fread(bufferOut, g_BootSector.BytesPerSector, count, disk) == count);
  return ok;
}

/**
 * Read FAT
 * 
 * @param *disk pointer to disk
 * @return boolean, false for error
 */
bool readFat(FILE* disk)
{
  g_Fat = (uint8_t*) malloc(g_BootSector.SectorsPerFat * g_BootSector.BytesPerSector);
  return readSectors(disk, g_BootSector.ReservedSectors, g_BootSector.SectorsPerFat, g_Fat)
}


int main(int argc, char** argv)
{
  if (argc < 3) 
  {
    printf("Syntax: %s <disk image> <file name>\n", argv[0]);
    return -1;
  }

  FILE* disk = fopen(argv[1], "rb");

  if (!disk) 
  {
    fprintf(stderr, "Cannot open disk image %s!\n", argv[1]);
    return -1;
  }

  if(!readBootSector(disk))
  {
    fprintf(stderr, "Could not read boot sector!\n");
    return -2;
  }

  if(!readFat(disk))
  {
    fprintf(stderr, "could not read FAT!\n");
    free(g_Fat);
    return -3;
  }
  
  free(g_Fat);
  return 0;
}
