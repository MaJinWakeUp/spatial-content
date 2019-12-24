# spatial-content (Revising...)
This is a Matlab implementation of our paper: 

**Spatial-Content Image Search in Complex Scenes.**

***Note**: Sorry that this repository may not contain every single step of our algorithm, some codes are lost due to my graduation from university. However, core function codes are still here.*
***

## Setup
* [Library yael][1]: Most functions are already contained in folder `utils`. Other functions needed could be found in this library.

## Step by step
1. Detect boxes using [YOLOv3][2].
2. Extract image features using Googlenet. In this paper, we use its Caffe implementation.
3. Build image representation.
4. Image search with our spatial-content similarity.


[1]: https://gforge.inria.fr/projects/yael/ "yael home"
[2]: https://pjreddie.com/darknet/yolo/ "YOLO"

