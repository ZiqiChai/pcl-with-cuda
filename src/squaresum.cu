#include <stdio.h>
#include <stdlib.h>
//#include "utils.h"
#include <iostream>
#include "squaresum.h"
// ======== define area ========
#define DATA_SIZE 1048576 // 1M

// ======== global area ========
int data[DATA_SIZE];

__global__ static void squaresSum(int *data, int *sum, clock_t *time)
{
 int sum_t = 0;
 clock_t start = clock();
 for (int i = 0; i < DATA_SIZE; ++i) {
  sum_t += data[i] * data[i];
 }
 *sum = sum_t;
 *time = clock() - start;
}

// ======== used to generate rand datas ========
void generateData(int *data, int size)
{
 for (int i = 0; i < size; ++i) {
  data[i] = rand() % 10;
 }
}

int squaresum()
{
 // init CUDA device
 if (!InitCUDA()) {
  return 0;
 }
 printf("CUDA initialized.\n");

 // generate rand datas
 generateData(data, DATA_SIZE);

 // malloc space for datas in GPU
 int *gpuData, *sum;
 clock_t *time;
 cudaMalloc((void**) &gpuData, sizeof(int) * DATA_SIZE);
 cudaMalloc((void**) &sum, sizeof(int));
 cudaMalloc((void**) &time, sizeof(clock_t));
 cudaMemcpy(gpuData, data, sizeof(int) * DATA_SIZE, cudaMemcpyHostToDevice);

 // calculate the squares's sum
 squaresSum<<<1, 1, 0>>>(gpuData, sum, time);

 // copy the result from GPU to HOST
 int result;
 clock_t time_used;
 cudaMemcpy(&result, sum, sizeof(int), cudaMemcpyDeviceToHost);
 cudaMemcpy(&time_used, time, sizeof(clock_t), cudaMemcpyDeviceToHost);

 // free GPU spaces
 cudaFree(gpuData);
 cudaFree(sum);
 cudaFree(time);

 // print result
 printf("(GPU) sum:%d time:%ld\n", result, time_used);

 // CPU calculate
 result = 0;
 clock_t start = clock();
 for (int i = 0; i < DATA_SIZE; ++i) {
  result += data[i] * data[i];
 }
 time_used = clock() - start;
 printf("(CPU) sum:%d time:%ld\n", result, time_used);

 return 0;
}