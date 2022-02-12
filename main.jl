using CSV
using DataFrames
using Distributions


mutable struct TreeNode
    # thuộc tính 
    dataset::Vector{Any}
    attribute_list::Vector{String}
    attribute_values::Dict{Any, Any}
    depth::Int64
    is_leaf::Bool
    split_attribute
    split
    left_child
    right_child
    prediction

    # chức năng 
    build
    predict
    merge_leaves
    print

    # định nghĩa hàm
    function TreeNode(training_set, attribute_list, attribute_values, tree_depth)
        this = new()

        this.dataset = training_set
        this.attribute_list = attribute_list
        this.attribute_values = attribute_values
        this.depth = tree_depth
        this.is_leaf = false
        this.split_attribute = nothing
        this.split = nothing
        this.left_child = nothing
        this.right_child = nothing
        this.prediction = nothing

        this.build = function()
            training_set = this.dataset
            if this.depth < MAX_TREE_DEPTH && length(training_set) >= MIN_SAMPLE_SIZE && length(Set([elem["species"] for elem in training_set])) > 1
                # nhận thuộc tính và phân chia với greatest information gain 
                max_gain, attribute, split = greatest_information_gain(this.attribute_list, this.attribute_values, training_set)
                # kiểm tra nếu info gain lớn hơn 0 (hoặc một tiêu chí dừng khác)
                if max_gain > 0
                    # split cây
                    this.split = split
                    this.split_attribute = attribute
                    # gen cây con
                    training_set_l = [elem for elem in training_set if elem[attribute] < split]
                    training_set_r = [elem for elem in training_set if elem[attribute] >= split]
                    this.left_child = TreeNode(training_set_l, this.attribute_list, this.attribute_values, this.depth + 1)
                    this.right_child = TreeNode(training_set_r, this.attribute_list, this.attribute_values, this.depth + 1)
                    this.left_child.build()
                    this.right_child.build()
                else
                    this.is_leaf = true
                end
            else
                this.is_leaf = true
            end
            if this.is_leaf
                # dự đoán lá phổ biến nhất trong training_set
                setosa_count = versicolor_count = virginica_count = 0
                for elem in training_set
                    if elem["species"] == "Iris-setosa"
                        setosa_count += 1
                    elseif elem["species"] == "Iris-versicolor"
                        versicolor_count += 1
                    else
                        virginica_count += 1
                    end
                end
                dominant_class = "Iris-setosa"
                dom_class_count = setosa_count
                if versicolor_count >= dom_class_count
                    dom_class_count = versicolor_count
                    dominant_class = "Iris-versicolor"
                end
                if virginica_count >= dom_class_count
                    dom_class_count = virginica_count
                    dominant_class = "Iris-virginica"
                end
                this.prediction = dominant_class
            end
        end

        # kiểm tra độ chính xác của cây quyết định
        this.predict = function(sample)
            if this.is_leaf
                return this.prediction
            else
                if sample[this.split_attribute] < this.split
                    return this.left_child.predict(sample)
                else
                    return this.right_child.predict(sample)
                end
            end
        end

        this.merge_leaves = function()
            if !this.is_leaf
                this.left_child.merge_leaves()
                this.right_child.merge_leaves()
                if this.left_child.is_leaf && this.right_child.is_leaf && this.left_child.prediction == this.right_child.prediction
                    this.is_leaf = true
                    this.prediction = this.left_child.prediction
                end
            end
        end

        this.print = function(prefix)
            if this.is_leaf
                println("\t" ^ this.depth, prefix, this.prediction)
            else
                println("\t" ^ this.depth, prefix, this.split_attribute, " < ", this.split, " ? ")
                this.left_child.print("-> True : ")
                this.right_child.print("-> False : ")
            end
        end

        return this
    end
end


mutable struct DecisionTree
    # thuộc tính 
    root

    # hàm 
    build
    merge_leaves
    predict
    print
    
    # định nghĩa hàm 
    function DecisionTree()
        this = new()

        this.root = nothing

        this.build = function(training_set, attribute_list, attribute_values)
            this.root = TreeNode(training_set, attribute_list, attribute_values, 0)
            this.root.build()
        end

        this.merge_leaves = function()
            this.root.merge_leaves()
        end

        this.predict = function(sample)
            return this.root.predict(sample)
        end

        this.print = function()
            println("************************")
            println("DECISION TREE")
            this.root.print("")
            println("END ALGORITHM")
            println("************************")
        end

        return this
    end
end


# tính toán entropy của thuộc tính được chỉ định 
function entropy(dataset)
    if length(dataset) == 0
        return 0
    end
    target_attribute_name = "species"
    target_attribute_values = ["Iris-setosa", "Iris-versicolor", "Iris-virginica"]
    entropy = 0
    for val in target_attribute_values
        # tính xác suất p để một phần tử trong tập hợp có giá trị là val
        p = length([elem for elem in dataset if elem[target_attribute_name] == val]) / length(dataset)
        if p > 0
            entropy += -p * log(2, p)
        end
    end
    return entropy
end


# tính toán entropy trung bình của thuộc tính, phép tách là giới hạn phân tách nhị phân cho thuộc tính
function information_gain(attribute_name, split, dataset)
    set_smaller = [elem for elem in dataset if elem[attribute_name] < split]
    p_smaller = length(set_smaller) / length(dataset)
    set_greater_equals = [elem for elem in dataset if elem[attribute_name] >= split]
    p_greater_equals = length(set_greater_equals) / length(dataset)
    # tính information gain
    info_gain = entropy(dataset)
    info_gain -= p_smaller * entropy(set_smaller)
    info_gain -= p_greater_equals * entropy(set_greater_equals)
    return info_gain
end


# Lấy criterion and optimal split để tính greatest in formation gain
function greatest_information_gain(attribute_list, attribute_values, dataset)
    greatest_info_gain = 0
    greatest_info_gain_attribute = nothing
    greatest_info_gain_split = nothing
    # duyệt qua thuộc tính
    for attribute in attribute_list  
        # kiểm tra tất cả các giá trị có thể có dưới dạng giới hạn phân chia
        for split in attribute_values[attribute] 
            # tính information gain
            split_info_gain = information_gain(attribute, split, dataset)  
            if split_info_gain >= greatest_info_gain
                greatest_info_gain = split_info_gain
                greatest_info_gain_attribute = attribute
                greatest_info_gain_split = split
            end
        end
    end
    return greatest_info_gain, greatest_info_gain_attribute, greatest_info_gain_split
end


function split_dataset(dataset)
    indexs = [i for i in 1:length(dataset)]
    test_indexs = sample(indexs, Int(length(indexs) / 3), replace = false)
    train_indexs = setdiff!(indexs, test_indexs)

    test_set = [dataset[i] for i in test_indexs]
    training_set = [dataset[i] for i in train_indexs]
    return test_set, training_set

end


function read_dataset()
    dataset = []
    df = CSV.read("/home/beiryu/Downloads/IrisFlowerID3/iris.csv", DataFrame)
    for row in eachrow(df)
        instance = Dict()
        instance["sepal_length"] = row["sepal_length"]
        instance["sepal_width"] = row["sepal_width"]
        instance["petal_length"] = row["petal_length"]
        instance["petal_width"] = row["petal_width"]
        instance["species"] = row["species"]
        push!(dataset, instance)
    end
    return dataset
end


function get_attributes(dataset)
    attr_domains = Dict()
    for attr in keys(dataset[1])   
        attr_domain = []
        for s in dataset
            if s[attr] ∉ attr_domain push!(attr_domain, s[attr]) end
        end
        attr_domains[attr] = attr_domain
    end
    return attr_domains
end


#Điều kiện dừng 
MIN_SAMPLE_SIZE = 4
MAX_TREE_DEPTH = 3


function main()
    
    #load dữ liệu hoa iris
    dataset = read_dataset()
    if isempty(dataset)
        println("Iris dataset is empty !!!")
        exit()
    end
    # chọn ngẫu nhiên 1/3 mẫu làm tập test, 2/3 mẫu làm tập train 
    test_set, training_set = split_dataset(dataset)

    # danh sách thuộc tính
    attr_list = ["sepal_length", "sepal_width", "petal_length", "petal_width"]
    attr_domains = get_attributes(dataset)
    
    # xây dựng cây quyết định 
    dt = DecisionTree()
    dt.build(training_set, attr_list, attr_domains)
    dt.merge_leaves()

    # tính toán độ chính xác với tập test
    accuracy = 0
    for sample in test_set
        if sample["species"] == dt.predict(sample)
            accuracy += (1 / length(test_set))
        end
    end

    # in ra cây 
    dt.print()
    println("Accuracy on test set: ", round(accuracy * 100, digits=2) , "%")
end


main()