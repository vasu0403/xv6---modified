#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main(int argc, char *argv[])
{
	for(int i = 0; i < 10000; i++){
		printf(1, "1");
	}
	exit();
}