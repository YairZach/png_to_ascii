
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


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

__global__ const string brightness = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_ + ~<>i!lI;:,\"^`'.";

__global__ void monochrome(int width, int height, int* in, int* out) {
	const int x = threadIdx.x;
	const int y = threadIdx.y;

	out[y * width + x] = (in[y * width + x + 0] + in[y * width + x + 1] + in[y * width + x + 2]) / 3;
}


int main(char** argv, int argc) {
	
	int x, y, n;
	unsigned char* data = stbi_load(argv[1], &x, &y, &n, 3);

	if (!(data != nullptr && x > 0 && y > 0)) return -1;
	if (n != 3) return -2;
	s
	unsigned char* mono = new unsigned char[y * x];

	string* output;

	

	stbi_image_free(data);

	int height = y / 20;
	int width = x / 20;



}
