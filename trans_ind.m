function index = trans_ind(box)
all_points = false(7,7);
x_start = max(floor(box(1)*7),1);
x_end = min(ceil((box(1)+box(3))*7),7);

y_start = max(floor(box(2)*7),1);
y_end = min(ceil((box(2)+box(4))*7),7);


all_points(y_start:y_end,x_start:x_end)=true;
index = find(all_points==1);
end