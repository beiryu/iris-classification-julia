## ID3 Triển khai tập dữ liệu về hoa Iris

ID3 là một thuật toán được Ross Quinlan phát minh vào năm 1986 để xây dựng cây quyết định dựa trên tiêu chí thu thập thông tin và không cắt tỉa.
Trong dự án này, thuật toán ID3 đã được sửa đổi để thực hiện tách nhị phân và áp dụng cho tập dữ liệu hoa Iris.

## Dataset
-------
[Tập dữ liệu về hoa Iris](https://archive.ics.uci.edu/ml/datasets/iris) bao gồm 50 mẫu từ mỗi loài trong số ba loài Iris (Iris Setosa, Iris virginica và Iris versicolor).
Mỗi bản ghi liệt kê sepal_length, sepal_width, wing_length, Pet_width và loài.

| sepal_length | sepal_width | wing_length | wing_width | loài |
| ------------ | ----------- | ------------ | ----------- | ----------- |
| 5,1 | 3,5 | 1,4 | 0,2 | Iris-setosa |
| 4,9 | 3 | 1,4 | 0,2 | Iris-setosa |
| 4,7 | 3,2 | 1,3 | 0,2 | Iris-setosa |
| 4,6 | 3,1 | 1,5 | 0,2 | Iris-setosa |
| ... | ... | ... | ... | ... |

## Tạo cây quyết định
------------------------

Thuật toán ID3 bắt đầu với một nút duy nhất và dần dần thực hiện tách nhị phân để thu được thông tin là tối đa.
Sự phát triển dừng lại trong quá trình thực hiện này, nếu tất cả các bản ghi trên một lá thuộc cùng một loài Iris, nếu độ sâu cây tối đa đạt được hoặc nếu số lượng mẫu trong một lá giảm xuống dưới ngưỡng.
Xem nhận xét về mã Python để có giải thích chi tiết hơn về cách cây quyết định được xây dựng.

Đầu ra
------
Chương trình xuất ra cây nhị phân đã tạo và tính toán độ chính xác của nó trên tập kiểm tra. Vì các tập huấn luyện và thử nghiệm được chọn ngẫu nhiên, cấu trúc của cây có thể khác nhau đối với nhiều lần thực thi chương trình.
