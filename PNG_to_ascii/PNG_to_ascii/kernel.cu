
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
using std::cin;

const string brightness = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_ + ~<>i!lI;:,\"^`'.";

__global__ void monochrome(int* width, unsigned char* in, unsigned char* out) {
	const int x = threadIdx.x;
	const int y = threadIdx.y;
	out[y * *width + x] = ((int)in[y * *width + x + 0] + (int)in[y * *width + x + 1] + (int)in[y * *width + x + 2]) / 3;
}

int main(char** argv, int argc) {
	
	string path;
	cin >> path;

	int x, y, n;
	unsigned char* data = stbi_load(path.c_str(), &x, &y, &n, 3);


	unsigned char* cudaData = 0;
	unsigned char* cudaMono = 0;
	int* cudaWidth = 0;


	if (!(data != nullptr && x > 0 && y > 0)) return -1;
	if (n < 3) return -2;

	cudaMalloc(&cudaWidth, sizeof(int));
	cudaMalloc(&cudaData, x * y * 3);
	cudaMalloc(&cudaMono, x * y);

	cudaMemcpy(cudaData, data, x * y * 3, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaWidth, &x, sizeof(int), cudaMemcpyHostToDevice);

	unsigned char* mono = new unsigned char[x * y];

	


	int numBlocks = 1;
	dim3 threadsPerBlock(x, y);
	monochrome<<<numBlocks, threadsPerBlock>>>(cudaWidth, cudaData, cudaMono);
	cudaMemcpy(mono, cudaMono, x*y, cudaMemcpyDeviceToHost);


	for (int i = 0; i < y; i++)
	{
		for (int j = 0; j < x; j++)
		{
			cout << (int)mono[i * x + j] << ", ";
		}
		cout << endl;
	}

	string* output;

	delete mono;
	stbi_image_free(data);

	int height = y / 20;
	int width = x / 20;



}
