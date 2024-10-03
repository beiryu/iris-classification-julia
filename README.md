# ID3 Algorithm Implementation for Iris Dataset

## Overview
This project implements a modified version of the ID3 (Iterative Dichotomiser 3) algorithm, originally invented by Ross Quinlan in 1986. The algorithm has been adapted to perform binary splits and is applied to the Iris flower dataset.

## Dataset
The [Iris flower dataset](https://archive.ics.uci.edu/ml/datasets/iris) contains 50 samples from each of three species of Iris (Iris Setosa, Iris virginica, and Iris versicolor). Each record includes the following attributes:

- Sepal length
- Sepal width
- Petal length
- Petal width
- Species

Example:

| Sepal Length | Sepal Width | Petal Length | Petal Width | Species |
|--------------|-------------|--------------|-------------|---------|
| 5.1          | 3.5         | 1.4          | 0.2         | Iris-setosa |
| 4.9          | 3.0         | 1.4          | 0.2         | Iris-setosa |
| 4.7          | 3.2         | 1.3          | 0.2         | Iris-setosa |
| 4.6          | 3.1         | 1.5          | 0.2         | Iris-setosa |
| ...          | ...         | ...          | ...         | ... |

## Decision Tree Generation

The modified ID3 algorithm starts with a single node and progressively performs binary splits to maximize information gain. The tree growth stops when:

1. All records in a leaf belong to the same Iris species
2. The maximum tree depth is reached
3. The number of samples in a leaf falls below a threshold

For a more detailed explanation of the decision tree construction, please refer to the comments in the Python code.

## Output

The program outputs the generated binary decision tree and calculates its accuracy on the test set. Note that the tree structure may vary between program executions due to random selection of training and test sets.

## Usage

[Add instructions on how to run the program, any dependencies required, and how to interpret the results.]

## Contributing

[Add information about how others can contribute to this project, if applicable.]

## License

[Specify the license under which this project is released, if applicable.]
