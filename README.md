#LBSideslipCell
##自定义tableViewCell侧滑按钮

自定义的UITableViewCell侧滑出现 “编辑” “删除”等自定义视图的控件

整个工程参考了网友的设计，有少许改动，目前还存在不少bug，有待进一步完善。

#组件
##ZYXSideslipCellAction
用于在代理中自定义视图
##ZYXSideslipCellDelegate
用于滑动cell的自定义事件回调
##ZYXSideslipCell
侧滑cell父类

#原理
创建自定义的button视图，将其插入到contentView下方，为contentView添加手势，根据pan的坐标移动，来改变contentView的frame。由于contentView上添加手势会导致其与tableView的滚动手势产生冲突，所以，要把contentView上的上下移动的手势禁止掉，只允许左右滑动，通过gesture的代理返回的bool值来禁止滑动手势。


