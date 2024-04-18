#include <iostream>
#include <stdlib.h>
#include <string>

extern "C" {
	#define STB_IMAGE_IMPLEMENTATION
	#include "stb_image.h"
}

using std::string;
using std::cout;
using std::endl;


int main(char** argv, int argc) {
	string brightness = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_ + ~<>i!lI;:,\"^`'.";
	int x, y, n;
	unsigned char* data = stbi_load(argv[1], &x, &y, &n, 3);

	if (!(data != nullptr && x > 0 && y > 0)) return -1;
	if (n != 3) return -2;

	unsigned char** mono = new unsigned char*[y];

	string* output;

	for (int i = 0; i < y; i++)
	{
		mono[i] = new unsigned char[x];
		for (int j = 0; j < x; j++)
		{
			mono[i][j] = (data[x * i + j] + data[x * i + j + 1] + data[x * i + j + 2]) / 3;
		}
	}

	stbi_image_free(data);

	int height = y / 20;
	int width = x / 20;



}
