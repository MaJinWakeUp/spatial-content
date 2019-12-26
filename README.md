# Spatial-Content Image Search(Revising...)
This is a Matlab implementation for our paper: 

**Spatial-Content Image Search in Complex Scenes.**

***Note**: Sorry that this repository may not contain every single step of our algorithm, some codes are lost due to my graduation from university. However, core function codes are still here.*
***

## Setup
* [Library yael][1]: Most functions are already contained in folder `/utils`. Other functions needed could be found in this library.

## Key steps
1. Detect boxes using [YOLOv3][2] (not include). 
2. Extract image features using Googlenet. In this paper, we use its [Caffe implementation][3] (not include).
3. Build image representation using `preprocess_data.m`.
4. Image search with our spatial-content similarity `test_spacon.m`.

## Meaning of other codes
* `extract_text.m` extract annotations from coco-api, then use `./pycode/create_tfidf.py` to calculate standard relevance score. As shown in paper 3.1.
* `modify_bboxes.m` change the format of original bounding boxes detected by yolov3.
* `postprocess.m` L2 normalization.
* `spaconsim.m` spatial-content similarity of two image.
* `trans_ind.m` a small function used in calculating one object's visual feature.



[1]: https://gforge.inria.fr/projects/yael/ "yael home"
[2]: https://pjreddie.com/darknet/yolo/ "YOLO"
[3]: https://github.com/BVLC/caffe "Caffe"
