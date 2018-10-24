#include <iostream>
#include <pcl/point_types.h>
#include <pcl/gpu/containers/device_array.h>

extern "C" {
	bool cloud2GPU(pcl::gpu::DeviceArray<pcl::PointXYZRGB>& cloud_device);
}