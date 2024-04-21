
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

/// <summary>
/// this function turns a pixel in an array of pixels monochrome running on gpu
/// </summary>
/// <param name="width">the horizontal resolution of the image</param>
/// <param name="in">array of rgb pixels, formatted with 3 fields for each pixel.</param>
/// <param name="out">array of monochrome pixels, out param</param>
/// <returns>void</returns>
__global__ void monochrome(const int& width, const unsigned char* in, unsigned char* out) {
	const int x = threadIdx.x;
	const int y = blockIdx.x;
	out[y * width + x] = ((int)in[y * width + x + 0] + (int)in[y * width + x + 1] + (int)in[y * width + x + 2]) / 3;
}


/// <summary>
/// this funtion chunks an array of monochrome pixels into a smaller array of monochrome pixels (downsacling)
/// </summary>
/// <param name="chunkSizeX">the hrizontal amout of pixels to merge</param>
/// <param name="chunkSizeY">the vertical amount of pixel to merge</param>
/// <param name="width">the width of one line of the "in" array</param>
/// <param name="in"> an array filled with monochrome Pixels</param>
/// <param name="out">the downscaled array, out param</param>
/// <returns>void</returns>
__global__ void Chunking(const int& chunkSizeX, const int& chunkSizeY, const int& width, const unsigned char* in, unsigned char* out) {
	const int x = threadIdx.x;
	const int y = blockIdx.x;
	int *sum = new int[chunkSizeY];

	sumChunk<<<1, chunkSizeY>>>(y * width + x, chunkSizeX, width, in, sum);

	int brt = 0;
	for (int i = 0; i < chunkSizeY; i++)
	{
		brt += sum[i];
	}

	brt /= chunkSizeX * chunkSizeY;
	out[x / chunkSizeX, y / chunkSizeY] = brt;
}

/// <summary>
/// this function sums all the values in a given slice of an array
/// </summary>
/// <param name="begins">where the slice begins</param>
/// <param name="length">the length of the slice</param>
/// <param name="width">the horizontal size of the "in" array</param>
/// <param name="in">array of WORD numbers</param>
/// <param name="out">array of WORD numbers, out param</param>
/// <returns>void</returns>
__global__ void sumChunk(const int& begins, const int& length, const int& width, const unsigned char* in, int* out) {
	const int x = threadIdx.x * width + begins;
	int out = 0;
	for (int i = 0; i < length; i++) {
		out[threadIdx.x] += in[x + i];
	}
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

	

	dim3 threadsPerBlock(x);
	int numBlocks = y;
	monochrome<<<numBlocks, threadsPerBlock.x>>>(cudaWidth, cudaData, cudaMono);

	cudaDeviceSynchronize();

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
