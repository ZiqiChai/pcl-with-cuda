/*
 * pcl_points_gpu.cpp
 *
 *  Created on: Nov 24, 2016
 *      Author: lzp
 */

#include "gpu_draw_cloud.h"
#include <pcl/io/pcd_io.h>

int main(int argc, char** argv)
{
    pcl::PointCloud<pcl::PointXYZRGB> cloud;
    pcl::gpu::DeviceArray<pcl::PointXYZRGB> cloud_device;


    cloud.width = 1;
    cloud.height =1;
    cloud.is_dense=false;
    cloud.points.resize(cloud.width*cloud.height);

    std::vector<float> point_val;

    for(size_t i=0; i<3*cloud.points.size(); ++i)
    {
        point_val.push_back(1024*rand()/(RAND_MAX+1.0f));
    }

    for (size_t i = 0; i < cloud.points.size(); ++i) {
        cloud.points[i].x = point_val[3 * i];
        cloud.points[i].y = point_val[3 * i + 1];
        cloud.points[i].z = point_val[3 * i + 2];
    }

    std::cout<<"cloud.points="<<cloud.points[0]<<std::endl;

    cloud_device.upload(cloud.points);

    cloud2GPU(cloud_device);

    cloud_device.download(cloud.points);

    std::cout<<"cloud.points="<<cloud.points[0]<<std::endl;
    return (0);
}