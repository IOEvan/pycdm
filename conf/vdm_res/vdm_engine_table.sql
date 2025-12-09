-- 麻烦根据以下表结构, 始终直接返回能够直接查询的sql，不需要格式和解释,不要忽略方位的要求(前方/后方/左方/右方)。根据提问内容自动确定查询的表和查询条件:
-- 下方所有列如果写‘[废弃]’,'[未测试]','[未开发]' 或者 '[不通过]'，编写sql的时候不能使用
-- ##警告## 的内容是需要非常重视的

-- ego表是自车表, 存储自车形式的各类信息：
DROP TABLE IF EXISTS ego;
CREATE TABLE IF NOT EXISTS ego ( 
    timestamp INT PRIMARY KEY, -- [测试通过] '时间戳'
    speed_kph FLOAT, -- [测试通过] '车速（公里/小时）'
    lgt_acceleration FLOAT, -- [测试通过] '纵向加速度，前正后负'
    lat_acceleration FLOAT, -- [测试通过] '横向加速度，右正左负'
    turn_yaw_rate FLOAT, -- [测试通过] '车转向角速度(度/秒, 非弧度制), degree 右正左负'
    vehicle_10ms_ad_deacc FLOAT, -- [测试通过] '智驾给出的减速度请求'
    act_gear TEXT, -- [测试通过] '当前档位。枚举内容：ActGear_Neutral：空档, ActGear_Drive：前进档, ActGear_Reverse：倒档, ActGear_Parking：驻车档, ActGear_Reserved1：保留1, ActGear_Reserved2：保留2, ActGear_Reserved3：保留3, ActGear_Invalid：无效'
    pedal_status TEXT, -- [测试通过] '踏板状态。枚举内容：BrkPdlSt_NotPrssd：未踩下, BrkPdlSt_Prssd：踩下, BrkPdlSt_Rsrvd2：保留2, BrkPdlSt_Invld：无效'
    aeb_status INT, -- [测试通过] '自动紧急制动状态。0：关闭, 1：打开'
    vehicle_50ms_turn_indicator_switch TEXT, -- [测试通过] '转向拨杆状态。枚举内容：TrnIndcr_Default：默认, TrnIndcr_Left：左转, TrnIndcr_Right：右转, TrnIndcr_InVld：无效'
    vehicle_50ms_front_wiper_switch_status TEXT, -- [测试通过] 'vehicle_50ms_front_wiper_switch_status:前雨刮开关状态。枚举内容：WiprSwt_Off：关闭, WiprSwt_LowSpd：低速, WiprSwt_HighSpd：高速, WiprSwt_IntrSpd：间歇速度, WiprSwt_OneTime：单次刮刷, WiprSwt_Rsrvd5：保留值 5, WiprSwt_Rsrvd6：保留值 6, WiprSwt_InVld：无效'
    vehicle_50ms_horn_status INT, -- [测试通过] '喇叭状态。0：关闭, 1：打开'
    ego_pwrswapproc TEXT, -- [未测试] '换电状态。枚举内容：No_action：未换电, PSAP：领航换电, Authen & Info_match & Vehicle_prepare & Swap_prepare & Swap_HV_battery & Diagnose & New_battery_info_match & Exit_PS：换电中，其他的为含义未知的预留字段。
    left_front_door_status TEXT, -- [未测试] '左前门开关状态。枚举内容：DrAjr_Opened：打开, DrAjr_Closed：关闭, DrAjr_Rsrvd2/DrAjr_InVld other
    left_rear_door_status TEXT, -- [未测试] '左后车门开关状态。枚举内容：DrAjr_Opened：打开, DrAjr_Closed：关闭, DrAjr_Rsrvd2/DrAjr_InVld other
    right_front_door_status TEXT, -- [未测试] '右前车门开关状态。枚举内容：DrAjr_Opened：打开, DrAjr_Closed：关闭, DrAjr_Rsrvd2/DrAjr_InVld other
    right_rear_door_status TEXT, -- [未测试] '右后车门开关状态。枚举内容：DrAjr_Opened：打开, DrAjr_Closed：关闭, DrAjr_Rsrvd2/DrAjr_InVld other
    hood_door_status TEXT, -- [未测试] '引擎盖开关状态。枚举内容：DrAjr_Opened：打开, DrAjr_Closed：关闭, DrAjr_Rsrvd2/DrAjr_InVld other
    swtich_da_nop INT, -- [未测试] '中控导航nop快捷开关。0：关闭, 1：打开'
    set_da_steer_assist TEXT, -- [未测试] '中控NP功能控制开关。枚举内容：SetDA_StrAssType_NoStrAss：无辅助, SetDA_StrAssType_WeakStrAss：弱辅助, SetDA_StrAssType_StronStrAss：强辅助, SetDA_StrAssType_InVld：无效'
    veh_state TEXT, -- [未实现] '车辆状态。枚举内容：VehSt_Park：停车, VehSt_DrvPrsnt：驾驶员在场, VehSt_Driving：行驶中, VehSt_SwUpdt：软件更新, VehSt_Charging：充电, VehSt_Pwrswap：换电, VehSt_Rsrvd6：保留6, VehSt_Rsrvd7：保留7, VehSt_Rsrvd8：保留8, VehSt_Rsrvd9：保留9, VehSt_Rsrvd10：保留10, VehSt_Rsrvd11：保留11, VehSt_Rsrvd12：保留12, VehSt_Rsrvd13：保留13, VehSt_Rsrvd14：保留14, VehSt_InVld：无效'
    light_status TEXT, -- [测试通过] '双闪灯状态。枚举内容：HzrdLi_Off：关闭, HzrdLi_Hzrd：危险灯, HzrdLi_Alarm：警报灯, HzrdLi_InVld：无效'
    set_da_psp INT, -- [未测试] 'PSP功能/换电领航功能开关。0：关闭, 1：打开'
    adasmap_is_highway INT, -- [不通过,准确率20%] '这车是否在高速上。1:是,0:否'
    sd_map_is_adasmap_valid INT, -- [不通过,准确率20%] 'ADAS地图是否有效。0：无效, 1：有效'
    sd_map_road_class TEXT, -- [不通过,省道以下准确率低] 'sd_map_road_class:道路类别。枚举内容：ROAD_CLASS_UNKNOWN：未知, HIGH_WAY_EXPRESS_WAY：高速公路, NATIONAL_ROAD：国道, PROVINCE_ROAD：省道, MAIN_ROAD_COUNTY_ROAD：主要县道/自车在主路, SECONDARY_ROAD_TOWNSHIP_ROAD：次级乡镇道路, NORMAL_ROAD_COUNTY_RURAL_INTERIOR_ROAD_AVENUE：普通道路, ROAD_CLASS_NA：不适用。 当查询在主路上的时候用MAIN_ROAD_COUNTY_ROAD'
    sd_map_form_of_way INT, -- [未测试] '道路细分类别。1:非支路/坡道的高速公路或受控通道,2:多车道或多重数字化道路,3:单行道,4:环形交叉口,5:交通广场/特殊交通图,6:出入口路,8:平行道路（作为特殊类型的支路/坡道）,9:高速公路或受控通道上的支路/坡道,10:支路/坡道（不在高速公路或受控通道上）,11:便道或临街道路,12:停车场的入口或出口,13:服务入口或出口,14:步行区'
    sd_map_seg_spd_lmt INT, -- [未测试] '当前道路限速，(公里/小时)'
    sd_map_is_tunnel INT, -- [测试通过] '是否处于隧道。0：否, 1：是'
    sd_map_is_bridge INT, -- [测试通过] '是否处于桥梁。0：否, 1：是'
    sd_map_navigation_state TEXT, -- [未测试] '导航状态。枚举内容：NS_NONE：无规划无导航, ROUTE_CRUISING：有规划无导航, ROAMING：导航计算中, NAVIGATING：导航中'
    sd_map_navigation_dist_to_first_turn INT, -- [测试通过] '距第一个转弯的距离'
    sd_map_navigation_first_turn INT,  -- [未测试] 假设UINT32可以用INT代,
    sd_map_navigation_dist_to_second_turn INT, -- [未测试] '距第二个转弯的距离'
    sd_map_navigation_second_turn INT, -- [未测试] '第二个转弯'
    num_of_lanes_opp_dir INT, -- [未测试] '前方道路对面车道数'
    num_of_lanes_drv_dir INT, -- [未测试] '前方道路本车道数'
    ads_ad_status INT, -- [测试通过] '智驾状态位。 0:init-初始化, 1:reserved-保留, 2: System Passive-系统被动, 3:PSP Standby-PSP待机, 4:ACC Standby-ACC待机, 5:Pilot Standby-Pilot待机, 6:ACC Active-ACC激活, 7:Pilot Active (long/lat)-Pilot激活（纵向/横向）, 8:Pilot Active (long.only)- Pilot激活（仅纵向）,9:NOP Active-NOP激活, 10:PSP Active-PSP激活, 11:NAD Active-NAD激活, 12:Risk Mitigation Procedure-风险缓解程序。其中0-5属于人驾状态，6-12属于自动驾驶状态' 
    ads_alc_status INT, -- [测试通过] '智驾换道状态位，注意：如果没有明确表示查询智能驾驶状态的换道，则需要使用sparse_tags表中的lanechange。枚举内容：0: NOP not engaged: NOP未激活, 1: Lane centering: 车道居中, 2: Preparing lane change toward left: 准备向左变道, 3: Preparing lane change toward right: 准备向右变道, 4: Executing lane change toward left: 执行向左变道, 5: Executing lane change toward right: 执行向右变道, 6: Aborting lane change into original lane: 放弃变道返回原车.##警告##只有涉及到自动驾驶或者智驾情景才可用此字段，其他变道场景一律不用此标签'
    global_localization_wgs48_x FLOAT, -- [未测试] '全球定位x坐标'
    global_localization_wgs48_y FLOAT, -- [未测试] '全球定位y坐标'
    global_localization_wgs48_z FLOAT, -- [未测试] '全球定位z坐标'
    global_localization_localization_status INT, -- [未测试] '全局定位状态。0:Not initialized yet: 尚未初始化, 1:Initializing in progress: 正在初始化, 2:Not converged yet: 尚未收敛, 3:Converged now, the localization module works: 已收敛，定位模块正常工作, 4:Localization module isnt fully constrained, such as in tunnel: 定位模块约束不完全，例如在隧道中, 5:Global localization not available: 全球定位不可用, 6:Sensor failure, such as abnormal value: 传感器故障，例如异常值' 
    global_localization_sd_link_id INT,  -- [未测试] 假设UINT64可以用BIGINT代替，但这里用INT简, -- [测试通过] 'SD地图链路ID'
    global_localization_sd_link_confidence INT, -- [未测试] 'SD地图链路置信度。0：低, 1：高'
    global_localization_curr_link_id INT, -- [未测试] '当前链路ID'
    global_localization_curr_lane_id INT, -- [未测试] '当前车道ID'
    global_localization_cartesian_position_x FLOAT, -- [未测试] '全局坐标系下自车的相对x位置，单位: m'
    global_localization_cartesian_position_y FLOAT, -- [未测试] '全局坐标系下自车的相对y位置，单位: m'
    global_localization_velocity_x FLOAT, -- [未测试] '全局坐标系下自车的x方向速度，单位: m/s'
    global_localization_velocity_y FLOAT, -- [未测试] '全局坐标系下自车的y方向速度，单位: m/s'
    global_localization_velocity_z FLOAT, -- [未测试] '全局坐标系下自车的z方向速度，单位: m/s'
    global_localization_linear_acc_x FLOAT, -- [未测试] '全局坐标系下自车的x方向加速度，单位: m/s^2'
    global_localization_linear_acc_y FLOAT, -- [未测试] '全局坐标系下自车的y方向加速度，单位: m/s^2'
    global_localization_linear_acc_z FLOAT, -- [未测试] '全局坐标系下自车的z方向加速度，单位: m/s^2'
    global_localization_angular_vel_x FLOAT, -- [未测试] '全局坐标系下自车的x方向角速度，单位: rad/s'
    global_localization_angular_vel_y FLOAT, -- [未测试] '全局坐标系下自车的y方向角速度，单位: rad/s'
    global_localization_angular_vel_z FLOAT, -- [未测试] '全局坐标系下自车的z方向角速度，单位: rad/s'
    global_localization_euler_angle_roll FLOAT, -- [未测试] '全局坐标系下自车的翻滚角, 单位：rad'
    global_localization_euler_angle_pitch FLOAT, -- [未测试] '全局坐标系下自车的俯仰角, 单位：rad'
    global_localization_euler_angle_yaw FLOAT, -- [未测试] '全局坐标系下自车的偏航角, 单位：rad'
    global_localization_loc_status INT, -- [未测试] 0: this map ele loc match failed; 1: this map ele loc match success
    relative_localization_linear_acc_x FLOAT, -- [未测试] '相对坐标系下自车的x方向加速度，单位: m/s^2'
    relative_localization_linear_acc_y FLOAT, -- [未测试] '相对坐标系下自车的y方向加速度，单位: m/s^2'
    relative_localization_linear_acc_z FLOAT, -- [未测试] '相对坐标系下自车的z方向加速度，单位: m/s^2'
    relative_localization_euler_angle_roll FLOAT, -- [未测试] '相对坐标系下自车的翻滚角, 单位：rad'
    relative_localization_euler_angle_pitch FLOAT, -- [未测试] '相对坐标系下自车的俯仰角, 单位：rad'
    relative_localization_euler_angle_yaw FLOAT, -- [未测试] '相对坐标系下自车的偏航角, 单位：rad'
    relative_localization_position_x FLOAT, -- [未测试] '相对坐标系下自车的x方向距离, 单位: m'
    relative_localization_position_y FLOAT, -- [未测试] '相对坐标系下自车的y方向距离, 单位: m'
    relative_localization_position_z FLOAT, -- [未测试] '相对坐标系下自车的z方向距离, 单位: m'
    planner_path_decision_types TEXT, -- [缺注释]
    car_state_wm_confidence TEXT, -- [未测试] '自车是否处于高精地图覆盖, 0:否,1:是'
    dynamic_map_tl_uturn_color TEXT, -- [测试通过] '自车受控的交通掉头灯颜色, UNKNOWN:未知,RED:红,YELLOW:黄,GREEN:绿,GRAY:灰'
    dynamic_map_tl_uturn_flash INT, -- [测试通过] '自车受控的交通掉头灯闪烁状态, 0: 常亮, 1: 闪烁'
    dynamic_map_tl_straight_color TEXT, -- [测试通过] '自车受控的交通直行灯颜色, UNKNOWN:未知,RED:红,YELLOW:黄,GREEN:绿,GRAY:灰'
    dynamic_map_tl_straight_flash INT, -- [测试通过] '自车受控的交通直行灯闪烁状态, 0: 常亮, 1: 闪烁'
    dynamic_map_tl_left_color TEXT, -- [测试通过] '自车受控的交通左转灯颜色, UNKNOWN:未知,RED:红,YELLOW:黄,GREEN:绿,GRAY:灰'
    dynamic_map_tl_left_flash INT, -- [测试通过] '自车受控的交通左转灯闪烁状态, 0: 常亮, 1: 闪烁'
    dynamic_map_tl_right_color TEXT, -- [测试通过] '自车受控的交通右转灯颜色, UNKNOWN:未知,RED:红,YELLOW:黄,GREEN:绿,GRAY:灰'
    dynamic_map_tl_right_flash INT, -- [测试通过] '自车受控的交通右转灯闪烁状态, 0: 常亮, 1: 闪烁'
    dynamic_map_distance_to_intersection_entry FLOAT, -- [测试通过] '自车距离下一个路口的距离  单位:m'
    global_hd_routes_distance_to_sd_end_m INT, -- [测试通过] '和导航终点的距离  单位:m'
    imu_roll FLOAT,      -- [未测试] 'imu翻滚角, 单位：rad'
    imu_pitch FLOAT,     -- [未测试] 'imu俯仰角, 单位：rad'
    imu_yaw FLOAT,       -- [测试通过] 'imu偏航角, 单位：rad'
    imu_acc_x FLOAT,     -- [未测试] 'imu 自车前向加速度 单位：m/s^2'
    imu_acc_y FLOAT,     -- [未测试] 'imu 自车侧向加速度 单位：m/s^2'
    imu_acc_z FLOAT,     -- [未测试] 'imu 自车垂直向加速度 单位：m/s^2'
    high_beam_status TEXT, -- [未测试] '远光灯状态。 Beam_Off:关闭,Beam_On:开启'
    low_beam_status TEXT, -- [未测试] '近光灯状态。 Beam_Off:关闭,Beam_On:开启'
    steer_wheel_ag FLOAT, -- [未测试] '方向盘转角 单位：rad'
    global_hd_routes_current_sd_link_id INT, -- [未测试] 
    global_hd_routes_current_sd_link_index INT, -- [未测试] 
    navi_stub_type TEXT, -- [未测试]
    navi_stub_is_controlled_by_traffic_light INT, -- [未测试]
    navi_stub_distance_to_intersection_center FLOAT, -- [未测试]
    navi_stub_turn_direction TEXT, -- [未测试]
    navi_stub_is_controlled_access INT, -- [未测试]
    navi_stub_sub_type TEXT, -- [未测试]
    manner_near_ego_lane_index INT, -- [未测试] manner感知自车所在车道索引，从左向右
    manner_far_ego_lane_index INT, -- [未测试] manner感知自车所在车道索引，从左向右
    vision_road_elevated_bridge_type INT, -- [未测试] 0: 非高架桥; 1: 桥下; 2: 桥上; 3: 高速匝道; 4: 匝道; 5: 未知;
    manner_distance_to_junction_entry FLOAT, -- [未测试] '自车距离下一个路口的距离  单位:m'
    ego_longitudinal TEXT, -- [测试通过]   没有全部实现后面的内容. 'ego_longitudinal:自车纵向状态。枚举内容：unknown：未知, constant_speed_constant：匀速行驶, accelerate_smooth：平稳加速, accelerate_sharp：急加速, decelerate_smooth：平稳减速, decelerate_sharp：急减速, stop：刹车停止, creep：蠕行。'
    ego_lateral_lane_center_middle INT, -- [测试通过] 'dense_ego_lateral_lane_center_middle:自车车道居中保持状态。1:车道居中,0:车道不居中'
    ego_junction_head_type_first INT, -- [测试通过] 自车是否是头车
    road_lane_line_curvature_curvature INT,-- [未实现] 'road_lane_line_curvature_curvature:自车当前道路曲率'
    light_weather_environment_weather TEXT, -- [废弃] 'light_weather_environment_weather:天气。rainy:雨天,fog:雾天,snow:雪天,sunny:晴天,cloudy:多云'
    light_weather_environment_unusual_weather TEXT, -- [废弃] 'light_weather_environment_unusual_weather: 特殊天气。groundwater:积水,sand_dust:沙尘,glare:炫光'
    light_weather_environment_illumination TEXT, -- [废弃] 'light_weather_environment_illumination: 光照条件。day:白天,morning:清晨,dusk:黄昏,night:夜晚,night_without_lights:夜晚无路灯'
    light_weather_image_quality_blockage TEXT, -- [废弃] 'light_weather_image_quality_blockage: 相机遮挡情况。slight:轻度遮挡,moderate:中度遮挡,severe:重度遮挡'
    light_weather_image_quality_smeared TEXT, -- [废弃] 'light_weather_image_quality_smeared: 相机炫光情况。halo_slight:轻度炫光,halo_severe:重度炫光'
    road_congestion INT, -- [不通过] 'road_congestion:道路拥堵等级。0:道路通畅,1:有车但不拥堵,2:一般拥堵,3:严重拥堵'
    lane_congestion INT, -- [测试通过] 'lane_congestion:车道拥堵等级。0:道路通畅,1:有车但不拥堵,2:一般拥堵,3:严重拥堵'
    lane_width FLOAT,    -- [测试通过] 'lane_width:自车道宽度  单位:m'
    dst_to_opening_junction INT, -- [测试通过] 自车和前方豁口的距离  单位 m
    ego_highway_urban TEXT -- [让步通过,准确率60%,待后续提高准确率] 'ego_highway_urban。 urban:自车处于城区, highway:自车处于高快，unknown:自车区域不明'
);

-- obj表存储自车以外的交通参与者的各类信息， 前方近处x方向0--15米，左右各8米的区域内
DROP TABLE IF EXISTS obj;
CREATE TABLE IF NOT EXISTS obj (
    timestamp INT, -- [测试通过] 'timestamp：时间戳。'
    id INT, -- [测试通过] 'id：对象ID。'
    is_dynamic INT, -- [测试通过] 'is_dynamic：是否动态。包括 0：非动态，1：动态。'
    fusion_source INT, -- [未测试] 'fusion_source：融合源。'
    multisource_objects_pos_x FLOAT, -- [测试通过] 'multisource_objects_pos_x：多源对象X坐标。'
    multisource_objects_pos_y FLOAT, -- [测试通过] 'multisource_objects_pos_y：多源对象Y坐标。'
    multisource_objects_pos_z FLOAT, -- [未测试] 'multisource_objects_pos_z：多源对象Z坐标。'
    multisource_objects_vel_x FLOAT, -- [未测试] 'multisource_objects_vel_x：多源对象X方向速度。单位m/s'
    multisource_objects_vel_y FLOAT, -- [未测试] 'multisource_objects_vel_y：多源对象Y方向速度。单位m/s'
    multisource_objects_vel_z FLOAT, -- [未测试] 'multisource_objects_vel_z：多源对象Z方向速度。单位m/s'
    multisource_objects_acc_x FLOAT, -- [未测试] 'multisource_objects_acc_x：多源对象X方向加速度。可以用于判断是加速还是减速'
    multisource_objects_acc_y FLOAT, -- [未测试] 'multisource_objects_acc_y：多源对象Y方向加速度。'
    multisource_objects_acc_z FLOAT, -- [未测试] 'multisource_objects_acc_z：多源对象Z方向加速度。'
    multisource_objects_width FLOAT, -- [未测试] 'multisource_objects_width：多源对象宽度。'
    multisource_objects_height FLOAT, -- [未测试] 'multisource_objects_height：多源对象高度。'
    multisource_objects_length FLOAT, -- [测试通过] 'multisource_objects_length：多源对象长度。'
    multisource_objects_heading FLOAT, -- [测试通过] 'multisource_objects_heading：多源对象航向角。'
    multisource_objects_heading_rate FLOAT, -- [未测试] 'multisource_objects_heading_rate：多源对象航向角速率。'
    objects_age INT, -- [未测试] 'objects_age：对象年龄（秒）。'
    objects_age_ms INT, -- [未测试] 'objects_age_ms：对象年龄（毫秒）。'
    objects_confidence FLOAT, -- [未测试] 'objects_confidence：对象置信度。'
    objects_tsi_id TEXT, -- [未测试] 'objects_tsi_id：对象TSI ID。'
    object_status TEXT, -- [测试通过] 'object_status：对象状态。包括 ObjStatus_Undefined：未定义，ObjStatus_Stopped：停止，ObjStatus_Moving：移动，ObjStatus_Oncoming：迎面而来，ObjStatus_Static：静态，ObjStatus_RearMoving：后向移动。'
    multisource_objects_brake_info TEXT, -- [未测试] 'multisource_objects_brake_info：多源对象刹车信息。包括 ObjLightStatus_Invalid：无效，ObjLightStatus_ON：开，ObjLightStatus_OFF：关。'
    multisource_objects_left_indicator TEXT, -- [测试通过] 'multisource_objects_left_indicator：多源对象左转向灯。包括 ObjLightStatus_Invalid：无效，ObjLightStatus_ON：开，ObjLightStatus_OFF：关。'
    multisource_objects_right_indicator TEXT, -- [测试通过] 'multisource_objects_right_indicator：多源对象右转向灯。包括 ObjLightStatus_Invalid：无效，ObjLightStatus_ON：开，ObjLightStatus_OFF：关。'
    motion_category TEXT, -- [不通过,先用着] '与自车的相对状态。枚举内容：ObjMotionCategory_Left_Crossing;ObjMotionCategory_Right_Crossing;ObjMotionCategory_Preceeding;ObjMotionCategory_Oncoming;ObjMotionCategory_Unknown'
    obj_orientation_lane_ownership TEXT, -- [测试通过] 'obj_orientation_lane_ownership:目标物车道归属。枚举内容：ObjLaneAssign_Unknown：未知, ObjLaneAssign_Host：本车道, ObjLaneAssign_Left：左侧车道, ObjLaneAssign_Right：右侧车道, ObjLaneAssign_Left_Left：左左车道, ObjLaneAssign_Right_Right：右右车道, ObjLaneAssign_Host_Left_Line：本车道左侧线, ObjLaneAssign_Host_Right_Line：本车道右侧线, ObjLaneAssign_Adjacent_Left_Left_Line：相邻左车道左侧线, ObjLaneAssign_Adjacent_Left_Right_Line：相邻左车道右侧线, ObjLaneAssign_Adjacent_Right_Left_Line：相邻右车道左侧线, ObjLaneAssign_Adjacent_Right_Right_Line：相邻右车道右侧线, ObjLaneAssign_LeftLeft_Left_Line：左左车道左侧线, ObjLaneAssign_LeftLeft_Right_Line：左左车道右侧线, ObjLaneAssign_RightRight_Left_Line：右右车道左侧线, ObjLaneAssign_RightRight_Right_Line：右右车道右侧线'
    obj_type TEXT, -- [测试通过] 'obj_type：对象类型。包括 ObjClass_Unknown：未知物体类型, ObjClass_SmallVehicle：小型车辆, ObjClass_Car：轿车, ObjClass_SUV：SUV, ObjClass_PickUp：皮卡, ObjClass_VAN：面包车, ObjClass_BigVehicle：大型车辆, ObjClass_Truck：卡车, ObjClass_BUS：公交车, ObjClass_Special_Truck：特种卡车, ObjClass_Trailer：挂车, ObjClass_Tricycle：三轮车, ObjClass_Two_wheels_vehicle：两轮车, ObjClass_Motorbike：摩托车, ObjClass_Ebike：电动车, ObjClass_Bicycle：自行车, ObjClass_Two_wheels_vehicle_P：两轮车（人）, ObjClass_Motorbike_P：摩托车（人）, ObjClass_Ebike_P：电动车（人）, ObjClass_Bicycle_P：自行车（人）, ObjClass_Pedestrian：行人, ObjClass_Adult：成人, ObjClass_Child：儿童, ObjClass_Animal：动物, ObjClass_Cat：猫, ObjClass_Dog：狗, ObjClass_Special：特殊物体, ObjClass_Pram：婴儿车, ObjClass_ShoppingCart：购物车, ObsType_Unknown：未知观测类型, ObsType_Barrel：桶, ObsType_Cone：锥体, ObsType_ShortPole：短杆, ObsType_ObstructionBW：前后障碍物, ObsType_ObstructionUP：上方障碍物, ObsType_ObstructionLeft：左侧障碍物, ObsType_ObstructionRight：右侧障碍物, ObsType_RedWarningSign：红色警告标志, ObsType_FishboneLeft：鱼骨线左侧, ObsType_FishboneRight：鱼骨线右侧, ObsType_OverheadObject：头顶上方物体, ObsType_Indicator_Arrow_Left：左箭头指示, ObsType_Indicator_Arrow_Right：右箭头指示, ObsType_Indicator_Arrow_Both：双向箭头指示, ObsType_Indicator_Arrow_Left_Up：左上箭头指示, ObsType_Indicator_Arrow_Left_Down：左下箭头指示, ObsType_Indicator_Arrow_Right_Up：右上箭头指示, ObsType_Indicator_Arrow_Right_Down：右下箭头指示, ObsType_MetalFence：金属围栏, ObsType_WarningPole：警告杆, ObsType_CircularColumn：圆柱, ObsType_StoneColumn：石柱, ObsType_OtherImpermanentObject：其他临时物体, ObsType_OtherPermanentObject：其他永久物体' --注意: VRU特指下面物体: ObjClass_Two_wheels_vehicle_P：两轮车（人）, ObjClass_Motorbike_P：摩托车（人）, ObjClass_Ebike_P：电动车（人）, ObjClass_Bicycle_P：自行车（人）, ObjClass_Pedestrian：行人, ObjClass_Adult：成人, ObjClass_Child：儿童. 其余的obj_type不是VRU
    obj_orientation_position_orientation TEXT, -- [测试通过] 'obj_orientation_position_orientation：对象位置方向。包括 Front：前方, LeftFront：左前方, RightFront：右前方, Left：左方, Right：右方, Back：后方, LeftBack：左后方, RightBack：右后方'
    obj_orientation_region_orientation TEXT, -- [测试通过] 'obj_orientation_region_orientation：对象区域方向。包括 unknown：未知，LeftBlindRegion：左盲区，RightBlindRegion：右盲区，FrontBlindRegion：前盲区，BackBlindRegion：后盲区。'
    obj_orientation_obj_distance TEXT, --[缺注释] 
    obj_closures_door_fl_open INT, -- [未实现] 'obj_closures_door_fl_open:对象左前车门开启状态。包括1:开启,0:关闭'
    obj_closures_door_fr_open INT, -- [未实现] 'obj_closures_door_fr_open:对象右前车门开启状态。包括1:开启,0:关闭'
    obj_closures_door_rl_open INT, -- [未实现] 'obj_closures_door_rl_open:对象左右车门开启状态。包括1:开启,0:关闭'
    obj_closures_door_rr_open INT, -- [未实现] 'obj_closures_door_rr_open:对象右右车门开启状态。包括1:开启,0:关闭'
    obj_closures_tailgate_rear_open INT, -- [未实现] 
    obj_closures_hood_front_open INT, -- [未实现] 
    obj_traffic_flow_vehicle_density TEXT, -- [未实现] 
    obj_traffic_flow_vru_density TEXT, -- [未实现] 
    obj_traffic_flow_vehicle_pedestrian_density TEXT, -- [未实现] 
    obj_interactive_attribute TEXT, -- [未实现] 
    obj_orientation_obj_lon_distance TEXT, -- [未实现] 'obj_orientation_obj_lon_distance:对象纵向时距类型。 包括 far_longitudinal:远纵向时距,mid_longitudinal:中纵向时距,close_longitudinal:近纵向时距'
    obj_orientation_obj_lat_distance TEXT, -- [未实现] 'obj_orientation_obj_lat_distance:对象纵向时距类型。 包括 far_lateral:远纵向时距,mid_lateral:中纵向时距,close_lateral:近纵向时距'
    obj_light_brake_info TEXT, -- [未实现] '对象刹车灯状态。ObjLightStatus_Invalid:无值,ObjLightStatus_ON:打开,ObjLightStatus_OFF:关闭'
    obj_light_left_indicator TEXT, -- [未实现] '对象左转向灯状态。ObjLightStatus_Invalid:无值,ObjLightStatus_ON:打开,ObjLightStatus_OFF:关闭'
    obj_light_right_indicator TEXT, -- [未实现] '对象右转向灯状态。ObjLightStatus_Invalid:无值,ObjLightStatus_ON:打开,ObjLightStatus_OFF:关闭'
    obj_light_reverse TEXT, -- [未实现] '对象倒车灯状态。ObjLightStatus_Invalid:无值,ObjLightStatus_ON:打开,ObjLightStatus_OFF:关闭'
    obj_light_hazard_light TEXT, -- [未实现] '对象双闪灯状态。ObjHBStatus_Off:关闭,ObjHBStatus_On:打开,ObjHBStatus_Blink:闪烁',
    obj_motion_category TEXT, -- [未实现]
    PRIMARY KEY (timestamp, id)
);

-- traffic_light 和 manner_virtual_traffic_light 请互斥使用，二者只能选择其一，后续可能下线traffic_light
DROP TABLE IF EXISTS traffic_light;
CREATE TABLE IF NOT EXISTS traffic_light ( -- 不建议使用
    timestamp INT,
    id INT, -- [未测试] 单独颜色的灯ID
    tld_panel_id INT, -- [未测试] 交通灯组ID
    tld_age INT, -- [未测试] 交通灯年龄
    tld_status INT, -- [未测试] 交通灯状态 0:常亮, 1:闪烁
    tld_timer INT, -- [未测试] 交通灯剩余时间读秒
    tld_dis3d_x FLOAT, -- [未测试] 交通灯在自车坐标系下的x坐标 单位: m
    tld_dis3d_y FLOAT, -- [未测试] 交通灯在自车坐标系下的y坐标 单位: m
    tld_dis3d_z FLOAT, -- [未测试] 交通灯在自车坐标系下的z坐标 单位: m
    tld_blocked INT, -- [未测试] 交通灯是否遮挡，0: 没有遮挡 1: 有遮挡
    tld_sence_type TEXT, -- [未测试] 
    tld_color_status TEXT, -- [未测试]
    tld_cap_semantic_info TEXT, -- [未测试]
    countdown_tld TEXT, -- [未测试]
    occulusion_info TEXT, -- [未测试]
    tld_existing_none_tld INT, -- [未测试]
    special_tld_scene TEXT, -- [未测试]
    lane_associated_info TEXT, -- [未测试]
    light_box_type TEXT, -- [未测试]
    flash_status TEXT, -- [未测试]
    tld_heading_info TEXT, -- [未测试]
    tld_tld_associated_info_associated INT, -- [未测试]
    tld_text_sematic_info TEXT, -- [未测试]
    tld_tld_text_sematic_info_glare_tld INT, -- [未测试]
    PRIMARY KEY (timestamp, id)
);
DROP TABLE IF EXISTS manner_virtual_traffic_light;
CREATE TABLE IF NOT EXISTS manner_virtual_traffic_light ( -- 建议使用
    timestamp INT,
    id INT, -- [未测试] 单独颜色的灯ID
    tld_direction TEXT, -- [未测试]
    tld_color TEXT, -- [未测试]
    tld_color_status INT, -- [未测试]
    tld_timer INT, -- [未测试] 交通灯剩余时间读秒
    tld_timer_progress INT, -- [未测试] 
    tld_blocked INT, -- [未测试] 交通灯是否遮挡，0: 没有遮挡 1: 有遮挡
    PRIMARY KEY (timestamp, id)
);

DROP TABLE IF EXISTS manner_lanes;
CREATE TABLE IF NOT EXISTS manner_lanes (
    timestamp INT,
    id INT,
    left_boundary_id INT,
    right_boundary_id INT,
    lane_type TEXT,
    is_on_nav INT,
    maximum_limit_speed FLOAT,
    maximum_limit_speed_source TEXT,
    direction TEXT,
    l_c0 FLOAT,
    l_c1 FLOAT,
    l_c2 FLOAT,
    l_c3 FLOAT,
    l_lrange_start FLOAT,
    l_lrange_end FLOAT,
    PRIMARY KEY (timestamp, id)
);
DROP TABLE IF EXISTS manner_lane_boundaries;
CREATE TABLE IF NOT EXISTS manner_lane_boundaries (
    timestamp INT,
    id INT,
    score FLOAT,
    on_route_flag INT,
    route_direction TEXT,
    b_c0 FLOAT,
    b_c1 FLOAT,
    b_c2 FLOAT,
    b_c3 FLOAT,
    b_lrange_start FLOAT,
    b_lrange_end FLOAT,
    PRIMARY KEY (timestamp, id)
);

DROP TABLE IF EXISTS lane_infos;
CREATE TABLE IF NOT EXISTS lane_infos (
    timestamp INT,
    id INT,
    age INT, -- [未测试] '检测到的时长' 
    confidence FLOAT, -- [未测试] '置信度'
    ld_role TEXT, -- [未测试] '车道线归属, LDRole_Unknown:未知,,LDRole_Host_Left:自车道的左车道线,LDRole_Host_Right:自车道的右车道线,LDRole_Adjacent_Left_Left:左车道的左车道线,LDRole_Adjacent_Left_Right:左车道的右车道线,LDRole_Adjacent_Right_Left:右车道的左车道线,LDRole_Adjacent_Right_Right:右车道的右车道线,LDRole_LeftLeft_Left:左二车道的左车道线,LDRole_LeftLeft_Right:左二车道的右车道线,LDRole_RightRight_Left:右二车道的左车道线,LDRole_RightRight_Right:右二车道的右车道线,LDRole_Fourth_Left:左三车道的左车道线,LDRole_Fourth_Right:左三车道的右车道线'
    ld_first_roleLine_is_virtual INT, -- [未测试] '车道线是否为虚拟线, 1:是, 0:否'
    ld_first_type TEXT, -- [未测试] '车道线类型, LDType_Unknown:未知,,LDType_Solid:实线,,LDType_Dash:虚线,LDType_Solid_Dash:实虚线,LDType_Dash_Solid:虚实线,LDType_Solid_Solid:双实线,LDType_Deceleration_Dash:减速虚线,LDType_Deceleration_Solid:减速实线,LDType_Guide:导流线,LDType_Dash_Dash:双虚线,LDType_Direct:可变导向线,LDType_Solid_Four:四实线'
    ld_first_color TEXT, -- [未测试] '车道线颜色 LDColor_Unknown:未知,LDColor_White:白色,LDColor_Yellow:黄色,LDColor_Orange:橘色,LDColor_Blue:蓝色,LDColor_Others:其他颜色,LDColor_Green:绿色,LDColor_Yellow_White:黄白色,LDColor_White_Yellow:白黄色'
    /*
        以下为车道线表达式的参数定义，以自车坐标系的xy方向用三次函数拟合，公式为 y = c0 + c1 * x + c2 * x^2 + c3 * x^3, 其中c0系数的含义为自车位置处的车道线和自车的距离，单位m，左负右正，c1系数为车道线和自车行进方向的角度斜率，c2系数为自车位置的车道线曲率, c3为曲率的变化率，start为车道线开始的纵向距离位置，end为车道线结束的纵向距离位置
    */
    ld_first_c0 FLOAT, -- [未测试] lane_infos.vision_road_detection_LD_First_Line.line_C0
    ld_first_c1 FLOAT,  -- [未测试] lane_infos.vision_road_detection_LD_First_Line.line_C1
    ld_first_c2 FLOAT,  -- [未测试] lane_infos.vision_road_detection_LD_First_Line.line_C2
    ld_first_c3 FLOAT,  -- [未测试] lane_infos.vision_road_detection_LD_First_Line.line_C3
    ld_first_start FLOAT,  -- [未测试] '车道线开始的纵向距离位置'
    ld_first_end FLOAT, -- [未测试] '车道线结束的纵向距离位置'
    ld_second_roleLine_is_virtual INT, -- [未测试] '车道线是否为虚拟线, 1:是, 0:否'
    ld_second_type TEXT, -- [未测试] '车道线类型, LDType_Unknown:未知,,LDType_Solid:实线,,LDType_Dash:虚线,LDType_Solid_Dash:实虚线,LDType_Dash_Solid:虚实线,LDType_Solid_Solid:双实线,LDType_Deceleration_Dash:减速虚线,LDType_Deceleration_Solid:减速实线,LDType_Guide:导流线,LDType_Dash_Dash:双虚线,LDType_Direct:可变导向线,LDType_Solid_Four:四实线'
    ld_second_color TEXT, -- [未测试] '车道线颜色 LDColor_Unknown:未知,LDColor_White:白色,LDColor_Yellow:黄色,LDColor_Orange:橘色,LDColor_Blue:蓝色,LDColor_Others:其他颜色,LDColor_Green:绿色,LDColor_Yellow_White:黄白色,LDColor_White_Yellow:白黄色'
    ld_second_c0 FLOAT, -- [未测试] lane_infos.vision_road_detection_LD_Second_Line.line_C0
    ld_second_c1 FLOAT, -- [未测试] lane_infos.vision_road_detection_LD_Second_Line.line_C1
    ld_second_c2 FLOAT, -- [未测试] lane_infos.vision_road_detection_LD_Second_Line.line_C2
    ld_second_c3 FLOAT, -- [未测试] lane_infos.vision_road_detection_LD_Second_Line.line_C3
    ld_second_start FLOAT, -- [未测试] '车道线开始的纵向距离位置'
    ld_second_end FLOAT, -- [未测试] '车道线结束的纵向距离位置'
    is_multi_clothoid INT, -- [缺注释]
    road_scene_lane_quantity TEXT, -- [缺注释]
    road_road_lane_blurred_lane_markings_severely_blurred INT, -- [缺注释]
    road_lane_lane_type TEXT, -- [缺注释]
    road_lane_line_mess TEXT, -- [缺注释]
    road_lane_line_type TEXT, -- [缺注释]
    road_lane_line_color TEXT, -- [缺注释]
    road_lane_line_blockage_type TEXT, -- [缺注释]
    PRIMARY KEY (timestamp, id)
);

-- traffic_sign 和 manner_traffic_sign 请互斥使用，二者只能选择其一，后续可能下线traffic_sign
DROP TABLE IF EXISTS traffic_sign;
CREATE TABLE IF NOT EXISTS traffic_sign ( -- 不建议使用
    timestamp INT,
    id INT, -- [未测试] 交通标志ID
    tsr_age INT, -- [未测试] 交通标志年龄
    tsr_long_dis FLOAT, -- [未测试] 交通标志x方向距离
    tsr_lat_dis FLOAT, -- [未测试] 交通标志y方向距离
    tsr_name TEXT, -- [未测试] '交通标志名 TSRName_Numerical_LimitSpd_Max:最高限速指示牌，TSRName_Numerical_LimitSpd_Min:最低限速指示牌，TSRName_Direct_Bus_Lane:公交专用道指示牌,TSRName_Direct_Right_Lane:右转车道指示牌,TSRName_Direct_Left_Lane:左转车道指示牌,TSRName_Direct_Straight_Lane:直行车道指示牌'
    tsr_shape TEXT, -- [未测试] 交通标志形状 TSRShape_Unknown:未知,TSRShape_Circle:圆形,TSRShape_Rectangle:方形,TSRShape_Triangular_Up:上三角形,TSRShape_Triangular_Down:下三角形
    tsr_structure TEXT, -- [未测试] 交通标志结构 TSRStructure_Unknown:未知,TSRStructure_Normal:普通,TSRStructure_Electronic:亮灯,TSRStructure_Variable:可变
    tsr_lane_assign TEXT, -- [未测试] 交通标志车道归属 LaneAssign_Unknown:未知,LaneAssign_Host_Lane:自车道,LaneAssign_Left_Lane:左车道,LaneAssign_Right_Lane:右车道,LaneAssign_Left_Left_Lane:左二车道,LaneAssign_Right_Right_Lane:右二车道
    road_traffic_sign_sign_type TEXT, -- [缺注释]
    road_traffic_sign_geometry_type TEXT, -- [缺注释]
    PRIMARY KEY (timestamp, id)
);
DROP TABLE IF EXISTS manner_traffic_sign;
CREATE TABLE IF NOT EXISTS manner_traffic_sign ( -- 建议使用
    timestamp INT,
    id INT, -- [未测试] 交通标志ID
    tsr_long_dis FLOAT, -- [未测试] 交通标志x方向距离
    tsr_lat_dis FLOAT, -- [未测试] 交通标志y方向距离
    tsr_name TEXT, -- [未测试] '交通标志名 '
    -- tsr_lane_assign TEXT, -- [未测试] 
    -- tsr_age INT, -- [未测试] 交通标志年龄
    -- tsr_shape TEXT, -- [未测试] 交通标志形状 TSRShape_Unknown:未知,TSRShape_Circle:圆形,TSRShape_Rectangle:方形,TSRShape_Triangular_Up:上三角形,TSRShape_Triangular_Down:下三角形
    -- tsr_structure TEXT, -- [未测试] 交通标志结构 TSRStructure_Unknown:未知,TSRStructure_Normal:普通,TSRStructure_Electronic:亮灯,TSRStructure_Variable:可变
    road_traffic_sign_sign_type TEXT, -- [缺注释]
    road_traffic_sign_geometry_type TEXT, -- [缺注释]
    PRIMARY KEY (timestamp, id)
);
-- roadsign 和 manner_roadsign 请互斥使用，二者只能选择其一，后续可能下线roadsign
DROP TABLE IF  EXISTS roadsign;
CREATE TABLE IF NOT EXISTS roadsign ( -- 不建议使用
    timestamp INT,
    id INT, -- [未测试] 路面标识ID
    age INT, -- [未测试] 路面标识年龄
    roadsign_center_x FLOAT, -- [未测试] 路面标识X坐标点
    roadsign_center_y FLOAT, -- [未测试] 路面标识Y坐标点
    roadsign_center_z FLOAT, -- [未测试] 路面标识Z坐标点
    roadsign_class TEXT, -- [测试通过] '路面标识类型 RoadSignClass_RoadArrow_Left:左转箭头, RoadSignClass_RoadArrow_Right:右转箭头,RoadSignClass_RoadArrow_Left_Right:左转右转箭头,RoadSignClass_RoadArrow_Straight:直行箭头,RoadSignClass_RoadArrow_Straight_Right:直行右转箭头,RoadSignClass_RoadArrow_Straight_Left:直行左转箭头,RoadSignClass_RoadArrow_Only_Turn:掉头箭头,RoadSignClass_RoadArrow_Left_Turn:左转掉头箭头,RoadSignClass_RoadArrow_Straight_Turn:直行掉头箭头,RoadSignClass_RoadArrow_Left_Merge:左弯或向左合流箭头,RoadSignClass_RoadArrow_Right_Merge:右弯或向右合流箭头,RoadSignClass_RoadArrow_Forbid_Sign:禁止符,RoadSignClass_ZebraCross:斑马线,RoadSignClass_NoParkingArea:禁止停车区,RoadSignClass_SpeedBump:减速带,RoadSignClass_PolePillar:杆状物'
    roadsign_confidence FLOAT,-- [未测试] 路面标识置信度
    roadsign_lane_assign TEXT,-- [未测试] 路面标识车道归属 LaneAssign_Host_Lane:自车道,LaneAssign_Left_Lane:左车道,LaneAssign_Right_Lane:右车道,LaneAssign_Left_Left_Lane:左二车道,LaneAssign_Right_Right_Lane:右二车道
    roadsign_color TEXT, -- [未测试] 路面标识颜色 RoadSignColor_White:白色,RoadSignColor_Yellow:黄色,RoadSignColor_Red:红色,RoadSignColor_Green:绿色
    roadsign_value FLOAT, -- [未实现]
    road_arrow_turn_arrow TEXT, -- [未实现]
    road_arrow_other_arrow TEXT, -- [未实现]
    road_arrow_text_arrow TEXT, -- [未实现]
    PRIMARY KEY (timestamp, id)
);
DROP TABLE IF  EXISTS manner_roadsign;
CREATE TABLE IF NOT EXISTS manner_roadsign ( -- 建议使用
    timestamp INT,
    id INT, -- [未测试] 路面标识ID
    roadsign_center_x FLOAT, -- [未测试] 路面标识X坐标点
    roadsign_center_y FLOAT, -- [未测试] 路面标识Y坐标点
    roadsign_center_z FLOAT, -- [未测试] 路面标识Z坐标点
    roadsign_class TEXT, -- [未测试] '路面标识类型 RoadSignClass_Unknown,RoadSignClass_StopLine,RoadSignClass_RoadArrow,RoadSignClass_RoadArrow_Left,RoadSignClass_RoadArrow_Right,RoadSignClass_RoadArrow_Left_Right,RoadSignClass_RoadArrow_Straight,RoadSignClass_RoadArrow_Straight_Right,RoadSignClass_RoadArrow_Straight_Left,RoadSignClass_RoadArrow_Only_Turn,RoadSignClass_RoadArrow_Left_Turn,RoadSignClass_RoadArrow_Straight_Turn,RoadSignClass_RoadArrow_Left_Merge,RoadSignClass_RoadArrow_Right_Merge,RoadSignClass_RoadArrow_Forbid_Sign,RoadSignClass_ZebraCross,RoadSignClass_NoParkingArea,RoadSignClass_SlowZone,RoadSignClass_SpeedBump,RoadSignClass_PolePillar,RoadSignClass_LimitSpd_Max,RoadSignClass_LimitSpd_Min,RoadSignClass_TextPattern,RoadSignClass_TextPattern_Yield,RoadSignClass_TextPattern_Stop,RoadSignClass_TextPattern_Variable,RoadSignClass_TextPattern_Reversible,RoadSignClass_TextPattern_Bike,RoadSignClass_TextPattern_Bus,RoadSignClass_TextPattern_HOV,RoadSignClass_TextPattern_TIME,RoadSignClass_TextPattern_WALK'
    roadsign_confidence FLOAT,-- [未测试] 路面标识置信度
    -- roadsign_lane_assign TEXT,-- [未测试] 
    -- roadsign_color TEXT, -- [未测试] 路面标识颜色 RoadSignColor_White:白色,RoadSignColor_Yellow:黄色,RoadSignColor_Red:红色,RoadSignColor_Green:绿色
    -- roadsign_value FLOAT, -- [未实现]
    road_arrow_turn_arrow TEXT, -- [未实现]
    road_arrow_other_arrow TEXT, -- [未实现]
    road_arrow_text_arrow TEXT -- [未实现]
    --PRIMARY KEY (timestamp, id) -- 暂时不使用主键，因为id是相同的（可能是manner map的bug）
);
-- roadedge 和 manner_roadedge 请互斥使用，二者只能选择其一，后续可能下线roadedge
DROP TABLE IF  EXISTS roadedge;
CREATE TABLE IF NOT EXISTS roadedge ( -- 不建议使用
    timestamp INT,
    id INT,
    ld_re_side TEXT, -- [未测试] 路沿方位 LDRESide_Left:左侧路沿,LDRESide_Right:右侧路沿
    ld_re_type TEXT, -- [未测试] 路沿可跨越类型 LDREType_Crossable:机动车和VRU均可跨越,LDREType_Uncrossable:机动车和VRU均不可跨越
    ld_re_age INT, -- [未测试] 路沿年龄
    ld_re_class TEXT, -- [未测试] 路沿种类 LDREClass_Cement_Block:固定矮路沿,LDREClass_Fence:固定高路沿,LDREClass_Cone:锥桶,LDREClass_Barrel:圆桶,LDREClass_Barrier:水马
    /*
        以下为路沿表达式的参数定义，以自车坐标系的xy方向用三次函数拟合，公式为 y = c0 + c1 * x + c2 * x^2 + c3 * x^3, 其中c0系数的含义为自车位置处的车道线和自车的距离，单位m，左负右正，c1系数为车道线和自车行进方向的角度斜率，c2系数为自车位置的车道线曲率, c3为曲率的变化率，ld_re_start为车道线开始的纵向距离位置，ld_re_end为车道线结束的纵向距离位置
    */
    ld_re_start FLOAT, -- [未测试]
    ld_re_end FLOAT, -- [未测试]
    ld_re_c0 FLOAT, -- [未测试]
    ld_re_c1 FLOAT, -- [未测试]
    ld_re_c2 FLOAT, -- [未测试]
    ld_re_c3 FLOAT, -- [未测试]
    road_road_edge_road_edge TEXT, -- [未实现]
    road_road_edge_hight_type TEXT, -- [未实现]
    PRIMARY KEY (timestamp, id)
);

DROP TABLE IF  EXISTS manner_roadedge;
CREATE TABLE IF NOT EXISTS manner_roadedge ( -- 建议使用
    timestamp INT,
    id INT,
    ld_re_class TEXT, -- [未测试] 路沿种类 LDREClass_Unknown,LDREClass_Cement_Block:指代固定矮路沿,LDREClass_Fence :指代固定高路沿,LDREClass_Cone:锥桶,LDREClass_Barrel:圆桶,LDREClass_Barrier:水马
    /*
        以下为路沿表达式的参数定义，以自车坐标系的xy方向用三次函数拟合，公式为 y = c0 + c1 * x + c2 * x^2 + c3 * x^3, 其中c0系数的含义为自车位置处的车道线和自车的距离，单位m，左负右正，c1系数为车道线和自车行进方向的角度斜率，c2系数为自车位置的车道线曲率, c3为曲率的变化率，ld_re_start为车道线开始的纵向距离位置，ld_re_end为车道线结束的纵向距离位置
    */
    ld_re_start FLOAT, -- [未测试]
    ld_re_end FLOAT, -- [未测试]
    ld_re_c0 FLOAT, -- [未测试]
    ld_re_c1 FLOAT, -- [未测试]
    ld_re_c2 FLOAT, -- [未测试]
    ld_re_c3 FLOAT, -- [未测试]
    -- ld_re_side TEXT, -- [未测试] 路沿方位 LDRESide_Left:左侧路沿,LDRESide_Right:右侧路沿
    -- ld_re_type TEXT, -- [未测试] 路沿可跨越类型 LDREType_Crossable:机动车和VRU均可跨越,LDREType_Uncrossable:机动车和VRU均不可跨越
    -- ld_re_age INT, -- [未测试] 路沿年龄
    road_road_edge_road_edge TEXT, -- [未实现]
    road_road_edge_hight_type TEXT, -- [未实现]
    PRIMARY KEY (timestamp, id)
);
-- stopline table 和 manner_stopline 请互斥使用，二者只能选择其一，后续可能下线stopline
DROP TABLE IF  EXISTS stopline;
CREATE TABLE IF NOT EXISTS stopline ( -- 不建议使用
    timestamp INT,
    id INT, -- [未测试] 停止线ID
    sl_type TEXT, -- [未测试] 停止线种类 SLType_Normal_StopLine:普通停止线,SLType_Intersection_StopLine:路口停止线,SLType_Turning_StopLine:待转区停止线,SLType_Zebra_StopLine:斑马线
    sl_probability FLOAT, -- [未测试] '停止线的置信度'
    sl_long_dis_l FLOAT, -- [未测试] '停止线左侧纵向距离 单位m'
    sl_long_dis_r FLOAT, -- [未测试] '停止线右侧纵向距离 单位m'
    sl_lat_dis_l FLOAT, -- [未测试] '停止线左侧横向距离 单位m'
    sl_lat_dis_r FLOAT, -- [未测试] '停止线右侧横向距离 单位m'
    for_nop INT, -- [未实现]
    sl_zebra_is_detected INT, -- [未测试] '是否检测到车道线. 枚举内容:1:是,0:否'
    junction_stop_line_stop_line_type TEXT, -- [未实现]
    junction_stop_line_blurred_stop_line_blurred INT, -- [未实现] 
    PRIMARY KEY (timestamp, id)
);

DROP TABLE IF  EXISTS manner_stopline;
CREATE TABLE IF NOT EXISTS manner_stopline ( -- 建议使用
    timestamp INT,
    id INT, -- [未测试] 停止线ID
    sl_probability FLOAT, -- [未测试] '停止线的置信度'
    sl_long_dis_l FLOAT, -- [未测试] '停止线左侧纵向距离 单位m'
    sl_long_dis_r FLOAT, -- [未测试] '停止线右侧纵向距离 单位m'
    sl_lat_dis_l FLOAT, -- [未测试] '停止线左侧横向距离 单位m'
    sl_lat_dis_r FLOAT, -- [未测试] '停止线右侧横向距离 单位m'
    --sl_type TEXT, -- [未测试] 停止线种类 SLType_Normal_StopLine:普通停止线,SLType_Intersection_StopLine:路口停止线,SLType_Turning_StopLine:待转区停止线,SLType_Zebra_StopLine:斑马线
    --for_nop INT, -- [未实现]
    --sl_zebra_is_detected INT, -- [未测试] '是否检测到斑马线. 枚举内容:1:是,0:否'
    junction_stop_line_blurred_stop_line_blurred INT, -- [未实现] 
    PRIMARY KEY (timestamp, id)
);

DROP TABLE IF EXISTS rme;
CREATE TABLE IF NOT EXISTS rme (
    timestamp INT,
    rme_eme_type TEXT, -- [测试通过] 归属后的车道线类型: HostLeft:自车车道左车道线,HostRight:自车车道右车道线, LeftLeft:左边车道的左车道线,RightRight:右边车道的右车道线,LeftRoadedge:左侧路沿,RightRoadedge:右侧路沿
    /*
        以下为路沿或者车道线的表达式的参数定义，以自车坐标系的xy方向用三次函数拟合，公式为 y = c0 + c1 * x + c2 * x^2 + c3 * x^3, 其中c0系数的含义为自车位置处的车道线和自车的距离，单位m，左负右正，c1系数为车道线和自车行进方向的角度斜率，c2系数为自车位置的车道线曲率, c3为曲率的变化率，start为车道线开始的纵向距离位置，end为车道线结束的纵向距离位置
    */
    rme_c0 FLOAT, -- [未测试] 
    rme_c1 FLOAT, -- [未测试] 
    rme_c2 FLOAT, -- [未测试] 
    rme_c3 FLOAT, -- [未测试] 
    rme_lrange_start FLOAT, -- [未测试] '车道线开始的纵向距离位置'
    rme_lrange_end FLOAT, -- [未测试] '车道线结束的纵向距离位置'
    rme_pt_conf FLOAT, -- [未测试] 'rme输出置信度'
    rme_source TEXT, -- [未测试] 枚举内容:'LINE:车道线,EDGE:道路边沿'
    ld_role TEXT, -- [未测试] 'LDRole_Unknown:未知,,LDRole_Host_Left:自车道的左车道线,LDRole_Host_Right:自车道的右车道线,LDRole_Adjacent_Left_Left:左车道的左车道线,LDRole_Adjacent_Left_Right:左车道的右车道线,LDRole_Adjacent_Right_Left:右车道的左车道线,LDRole_Adjacent_Right_Right:右车道的右车道线,LDRole_LeftLeft_Left:左二车道的左车道线,LDRole_LeftLeft_Right:左二车道的右车道线,LDRole_RightRight_Left:右二车道的左车道线,LDRole_RightRight_Right:右二车道的右车道线,LDRole_Fourth_Left:左三车道的左车道线,LDRole_Fourth_Right:左三车道的右车道线'
    ld_first_roleLine_is_virtual INT, -- [未测试] '车道线是否为虚拟线, 1:是, 0:否'
    ld_first_type TEXT, -- [未测试] '车道线类型, LDType_Unknown:未知,,LDType_Solid:实线,,LDType_Dash:虚线,LDType_Solid_Dash:实虚线,LDType_Dash_Solid:虚实线,LDType_Solid_Solid:双实线,LDType_Deceleration_Dash:减速虚线,LDType_Deceleration_Solid:减速实线,LDType_Guide:导流线,LDType_Dash_Dash:双虚线,LDType_Direct:可变导向线,LDType_Solid_Four:四实线'
    ld_first_color TEXT, -- [未测试] '车道线颜色 LDColor_Unknown:未知,LDColor_White:白色,LDColor_Yellow:黄色,LDColor_Orange:橘色,LDColor_Blue:蓝色,LDColor_Others:其他颜色,LDColor_Green:绿色,LDColor_Yellow_White:黄白色,LDColor_White_Yellow:白黄色'
    ld_second_roleLine_is_virtual INT, -- [未测试] '车道线是否为虚拟线, 1:是, 0:否'
    ld_second_type TEXT, -- [未测试] '车道线类型, LDType_Unknown:未知,,LDType_Solid:实线,,LDType_Dash:虚线,LDType_Solid_Dash:实虚线,LDType_Dash_Solid:虚实线,LDType_Solid_Solid:双实线,LDType_Deceleration_Dash:减速虚线,LDType_Deceleration_Solid:减速实线,LDType_Guide:导流线,LDType_Dash_Dash:双虚线,LDType_Direct:可变导向线,LDType_Solid_Four:四实线'
    ld_second_color TEXT, -- [未测试] '车道线颜色 LDColor_Unknown:未知,LDColor_White:白色,LDColor_Yellow:黄色,LDColor_Orange:橘色,LDColor_Blue:蓝色,LDColor_Others:其他颜色,LDColor_Green:绿色,LDColor_Yellow_White:黄白色,LDColor_White_Yellow:白黄色'
    ld_re_side TEXT, -- [未测试] '路沿方位 LDRESide_Left:左侧路沿,LDRESide_Right:右侧路沿'
    ld_re_type TEXT, -- [未测试] '路沿可跨越类型 LDREType_Crossable:机动车和VRU均可跨越,LDREType_Uncrossable:机动车和VRU均不可跨越'
    ld_re_age INT, -- [未测试] '路沿年龄'
    ld_re_class TEXT, -- [未测试] '路沿种类 LDREClass_Cement_Block:固定矮路沿,LDREClass_Fence:固定高路沿,LDREClass_Cone:锥桶,LDREClass_Barrel:圆桶,LDREClass_Barrier:水马'
    PRIMARY KEY (timestamp, rme_eme_type)
);


DROP TABLE IF EXISTS navigation_link_shape_points;
CREATE TABLE IF NOT EXISTS navigation_link_shape_points (
    timestamp INT,
    link_id INT, 
    shape_point_index INT, -- 原始信息没有是中间层按照原始数值索引生成的
    latitude FLOAT, 
    longitude FLOAT, 
    bearing FLOAT, 
    altitude FLOAT, 
    location_type TEXT,
    PRIMARY KEY (timestamp, link_id, shape_point_index));

DROP TABLE IF EXISTS navigation_link_info;
CREATE TABLE IF NOT EXISTS navigation_link_info (
    timestamp INT,
    link_id INT, 
    link_index INT, -- 原始信息没有是中间层按照原始数值索引生成的
    link_length INT,
    road_class TEXT, 
    road_name TEXT, 
    is_overhead INT, 
    has_parallel INT, 
    has_multiout INT, 
    has_mixfork INT, 
    link_direct INT, 
    is_toll INT, 
    lane_num INT,
    speed_limit INT,
    history_speed INT, 
    travel_time INT, 
    link_type INT,        -- -1 	无效, 0  普通道路,1 	航道, 2 	隧道,3 	桥梁,4 	高架路
    owner_ship INT,    -- 0 公共道路, 1 内部道路, 2 私有道路, 3 地下停车场道路, 4 立体停车场道路
    main_action INT,
    assistant_action INT,
    request_id TEXT,
    link_length_calc_by_points INT,
    PRIMARY KEY (timestamp, link_id, link_index));

DROP TABLE IF EXISTS navigation_lane_info;
CREATE TABLE IF NOT EXISTS navigation_lane_info (
    timestamp INT,  
    lane_index INT,   -- [测试通过] 当前车道处于从左往右第几条。从0开始
    lane_change_type INT,  -- [测试部分通过 右侧拓展、左侧拓展通过 右侧收窄、左侧收窄不通过] 车道拓展类型（4bit）。0 无；1 右侧拓展；2 右侧收窄；4 左侧收窄；8 左侧拓展
    lane_highline_direction INT,  -- [测试通过] 车道高亮方向（5bit）。指车道方向中高亮的方向，由基础方向叠加构成，导航时只高亮一个基础方向，巡航时全亮显示。基础方向如下：0(00000) None；1(00001) 右掉头；2(00010) 右转；4(00100) 直行；8(01000) 左转；16(10000) 左掉头。
    lane_direction INT, -- [测试通过] 车道方向 0:None,1:右掉头,2:右转,4:直行,5:右掉头与直行,6:右转与直行,8:左转,9:左转与右掉头,10:左转与右转,12:直行与左转,14:直行与左转与右转,16:左掉头,18:右转与左掉头,20:直行与左掉头,24:左转与左掉头,26:右转与左转与左掉头,28:直行与左转与左掉头。
    lane_type INT,  -- [测试部分通过 公交车道通过 潮汐车道不通过]车道类型（6bit）。 0 无效车道；1 普通车道；2 公交车道；3 公交车道文字；4 可变车道；5 HOV；6 潮汐车道文字；7 潮汐车道前行箭头；8 潮汐车道叉号；9 ETC（百度引擎）； 10 ETC（高德引擎）
    PRIMARY KEY (timestamp, lane_index)
);

-- navigation_info, 存储导航信息。表示导航状态的字段有3个:reliable_state,navigation_state,navigation_state_tag. 只有当reliable_state为7 且 navigation_state为3时才为'导航状态'，其他均为'偏航状态'(即没有遵循导航)。
DROP TABLE IF EXISTS navigation_info;
CREATE TABLE IF NOT EXISTS navigation_info (
    timestamp INT PRIMARY KEY,  -- [测试通过] '时间戳'
    map_loc_timestamp INT,  -- [测试通过] '导航信息时间戳'
    reliable_state INT,  -- [测试通过]  '可靠状态'   0:RS_NONE,1: UNRELIABLE,2:UNRELIABLE_ROUTING,3:UNRELIABLE_YAWING,4:UNRELIABLE_SWITCHING,5:UNRELIABLE_UNKNOWN,6:UNRELIABLE_MAX,7:RELIABLE
    navigation_state INT,  -- [测试通过] '导航状态'      0:NS_NONE, 1:ROUTE_CRUISING, 2:ROAMING, 3:NAVIGATING
    traffic_light_direction INT,  -- [测试通过] '红绿灯方向'。枚举内容：1:左转，2:右转，7:调头，8:直行
    traffic_light_type INT,  -- [测试通过] '红绿灯状态'。 枚举内容: 1:红灯倒计时，10:绿灯可通行，20:即将变红灯
    traffic_light_countdown INT, -- [未实现] '红绿灯倒计时'。单位：秒
    traffic_light_distance FLOAT,  -- [测试通过] '红绿灯距离'。单位：米
    traffic_light_state_stime INT,  -- [未测试] '红绿灯状态开始时间'
    traffic_light_state_etime INT,  -- [未测试] '红绿灯状态结束时间'
    speed_limit_info INT,  -- [测试通过] '限速信息'
    node_speed_limit INT, -- [未测试]
    node_speed_limit_type INT, -- [未测试]
    lane_count INT,  -- [测试通过] '车道数'
    lane_nr_info TEXT, -- [测试通过] '车道信息'
    dist_to_lane_info_guide INT,  -- [测试通过] '距离车道指示线指示点距离'。单位：米
    road_class INT, -- [不通过] '道路类别'。枚举内容: 0: 未知，1: 高速公路，2: 城市快速路，3: 国道，4: 省道，5: 县道，6: 乡道，7: 其他道路，8: 非导航道路，9: 人行道，10: 渡口，11: RMAX
    form_of_way INT, -- [未测试]
    map_loc_ownership INT, -- [未测试] '道路所有权信息'。0 公共道路, 1 内部道路, 2 私有道路, 3 地下停车场道路, 4 立体停车场道路
    main_action INT, -- [测试通过] '主要action'。 枚举内容：-2147483648: 非法操作错误，0: 无基本导航动作，1: 左转，2: 右转，3: 向左前方行驶，4: 向右前方行驶，5: 向左后方行驶，6: 向右后方行驶，7: 左转调头，8: 直行，9: 靠左，10: 靠右，11: 进入环岛，12: 离开环岛，13: 减速行驶，14: 插入直行（泛亚特有），65: 进入建筑物，66: 离开建筑物，67: 电梯换层，68: 楼梯换层，69: 扶梯换层，70: 导航主动作最大个数
    assistant_action INT, -- [测试通过] '辅助action'。 枚举内容：0: 无辅助导航动作，1: 进入主路，2: 进入辅路，3: 进入高速，4: 进入匝道，5: 进入隧道，6: 进入中间岔道，7: 进入右岔路，8: 进入左岔路，9: 进入右转专用道，10: 进入左转专用道，11: 进入中间道路，12: 进入右侧道路，13: 进入左侧道路，14: 靠右行驶进入辅路，15: 靠左行驶进入辅路，16: 靠右行驶进入主路，17: 靠左行驶进入主路，18: 靠右行驶进入右转专用道，19: 到达航道，20: 驶离轮渡，23: 沿当前道路行驶，24: 沿辅路行驶，25: 沿主路行驶，32: 到达出口，33: 到达服务区，34: 到达收费站，35: 到达途经地，36: 到达目的地，37: 到达充电站，新能源汽车专用，48: 绕环岛左转，49: 绕环岛右转，50: 绕环岛直行，51: 绕环岛调头，52: 小环岛不数出口，64: 到达复杂路口，走右边第一出口，65: 到达复杂路口，走右边第二出口，66: 到达复杂路口，走右边第三出口，67: 到达复杂路口，走右边第四出口，68: 到达复杂路口，走右边第五出口，69: 到达复杂路口，走左边第一出口，70: 到达复杂路口，走左边第二出口，71: 到达复杂路口，走左边第三出口，72: 到达复杂路口，走左边第四出口，73: 到达复杂路口，走左边第五出口，80: 进入调头专用路，90: 通过人行横道，91: 通过过街天桥，92: 通过地下通道，93: 通过广场，94: 通过公园，95: 通过扶梯，96: 通过直梯，97: 通过索道，98: 通过空中通道，99: 通过建筑物穿越通道，100: 通过行人道路，101: 通过游船路线，102: 通过观光车路线，103: 通过滑道，105: 通过阶梯，106: 通过斜坡，107: 通过桥，108: 通过轮渡，109: 通过地铁通道，112: 即将进入建筑 (当前未下发)，113: 即将离开建筑 (当前未下发)，114: 进入环岛 (骑步特有)，115: 离开环岛 (骑步特有)，116: 进入小路，117: 进入内部路，118: 进入左侧第二岔路，119: 进入左侧第三岔路，120: 进入右侧第二岔路，121: 进入右侧第三岔路，122: 进入加油站道路，123: 进入小区道路，124: 进入园区道路，125: 上高架，126: 走中间岔路上高架，127: 走最右侧岔路上高架，128: 走最左侧岔路上高架，129: 沿当前道路直行，130: 下高架，131: 走左侧道路上高架，132: 走右侧道路上高架，133: 上桥，134: 进停车场，135: 进入立交桥，136: 进入桥梁，137: 进入地下通道，4096: 辅动作最大值
    link_id INT, -- [测试通过] '导航信息所在的link_id'
    link_index INT, -- [未测试] '导航信息所在的link_index'
    link_length FLOAT, -- [未测试] '导航信息所在的link的长度'
    link_type INT, -- [未测试] 
    link_remain_dist FLOAT, -- [未测试] '导航信息所在的link的剩余距离'
    last_route_count INT, -- [未测试] '导航中路线变更的次数'
    jumping_reliable_state INT, -- [未测试] '导航状态跳变时出现的稳定性状态'
    jumping_navigation_state INT, -- [未测试] '导航状态跳变时出现的导航状态'
    navigation_yaw_flag INT , -- [未测试] '上一秒是否发生了偏航'
    speech_content TEXT, -- '语音播报信息'
    speech_type INT, -- '语音播报类型。1: "detail";2: "simple";3: "ExtremelySimple";4: "mute"
    pre_action_dist FLOAT, -- [未测试] '上一个action的距离, 数据为负值'
    pre_main_action INT, -- [未测试] '上一个主要action'
    pre_assistant_action INT, -- [未测试] '上一个辅助action'
    next_action_dist FLOAT, -- [未测试] '下一个action的距离, 数据为负值'
    next_main_action INT, -- [未测试] '下一个主要action'
    next_assistant_action INT, -- [未测试] '下一个辅助action'
    next_next_action_dist FLOAT, -- [未测试] '下下一个action的距离, 数据为负值'
    next_next_main_action INT, -- [未测试] '下下一个主要action'
    next_next_assistant_action INT -- [未测试] '下下一个辅助action'
);

DROP TABLE IF EXISTS parking_slot_info;
CREATE TABLE IF NOT EXISTS parking_slot_info (
    timestamp INT, -- [测试通过] '时间戳'
    hmi_index INT, -- [测试通过] 'HMI索引，用于标识停车点的编号或ID'
    type TEXT,  -- [测试通过] '停车位类型，表示平行、垂直或其他类型。 枚举内容：LeftCrossParkIn:左侧垂直车位;RightCrossParkIn:右侧垂直车位;LeftParallelParkIn:左侧平行车位;RightParallelParkIn:右侧平行车位;LeftAngledParkIn:左侧倾斜车位;RightAngledParkIn:右侧倾斜车位;Left_PSAP_In:左侧换电站'
    left_corner_exist INT, -- [测试通过] '车位左侧是否存在障碍物，1表示存在，0表示不存在'
    left_corner_type TEXT, -- [测试通过] '车位左侧障碍物类型。 枚举内容：null:无障碍物;CornerType_Car:车;CornerType_Curb:路边路缘;CornerType_Pillar:柱子;CornerType_Unknown:未知;CornerType_Wall:墙壁'
    right_corner_exist INT,  -- [测试通过] '车位右侧是否存在障碍物，1表示存在，0表示不存在'
    right_corner_type TEXT,  -- [测试通过] '车位右侧障碍物类型。 枚举内容：null:无障碍物;CornerType_Car:车;CornerType_Curb:路边路缘;CornerType_Pillar:柱子;CornerType_Unknown:未知;CornerType_Wall:墙壁'
    slot_attribute_0 INT, -- [不通过] '是否是断头路/端头路。 枚举内容：1:是;0:不是。 不准'
    slot_attribute_1 INT, -- [不通过] 'mechanical (stereo) 不准'
    slot_attribute_2 INT, -- [不通过] 'charging 不准'
    slot_attribute_3 INT, -- [不通过] 'handicap 不准'
    slot_attribute_4 INT, -- [不通过] 'parklock 不准'
    slot_attribute_5 INT, -- [不通过] 'channel_blocked 通道是否拥堵。 枚举内容：1:表示拥堵;0:不拥堵. 不准'
    slot_attribute_6 INT, -- [不通过] 'recommended 是否是推荐的车位。枚举内容：1:是;0:不是。 不准'
    slot_attribute_7 INT, -- [不通过] '预留的空置，目前无数值'
    corner_corner_dist FLOAT, -- [测试通过] '车位宽度。单位: m'
    channel_width FLOAT, -- [测试通过] '车道宽度。单位: m'
    left_corner_line_dist FLOAT, -- [测试通过] '当前车位右边线到左侧车位右边线的距离。单位: m'
    right_corner_line_dist FLOAT, -- [测试通过] '当前车位左边线到左侧车位左边线的距离。单位: m'
    size_x FLOAT,  -- [测试通过] '车位在自车x方向的尺寸。 单位:m'
    size_y FLOAT,  -- [测试通过] '车位在自车y方向的尺寸。 单位:m'
    slot_bumper INT, -- [不通过] '是否存在停车位的挡车器或防撞装置，1表示存在，0表示不存在'
    iou FLOAT, -- [测试通过] '车与停车点之间的iou'
    is_target INT, -- [测试通过] '是否为目标停车位。 枚举内容:1:是;0:不是。'
    PRIMARY KEY (timestamp, hmi_index));

DROP TABLE IF EXISTS parking_ego_info;
CREATE TABLE IF NOT EXISTS parking_ego_info (
    timestamp INT PRIMARY KEY, -- [测试通过] '时间戳'
    forward_dst FLOAT, -- [测试通过] '按照预测轨迹,前向障碍物距离'
    backward_dst FLOAT, -- [测试通过] '按照预测轨迹,后向障碍物距离'
    direct_forward_dst FLOAT, -- [测试通过] '前向障碍物距离'
    direct_backward_dst FLOAT, -- [测试通过] '后向障碍物距离'
    left_dst FLOAT, -- [测试通过] '按照预测轨迹,左侧障碍物距离'
    right_dst FLOAT, -- [测试通过] '按照预测轨迹,右侧障碍物距离'
    min_left_dst FLOAT, -- [未测试] '左侧障碍物最近距离'
    min_right_dst FLOAT, -- [未测试] '右侧障碍物最近距离'
    forward_left_dst FLOAT, -- [未测试] '左前方障碍物最近距离'
    forward_right_dst FLOAT, -- [未测试] '右前方障碍物最近距离'
    backward_left_dst FLOAT, -- [未测试] '左后方障碍物最近距离'
    backward_right_dst FLOAT, -- [未测试] '右后方障碍物最近距离'
    /* 以下的字段forward_collision_object,backward_collision_object,direct_forward_collision_object,direct_backward_collision_object,left_collision_object,right_collision_object都是描述障碍物类别。枚举内容:CollisionObject_Vehicle:车,CollisionObject_Pedestrian:行人,CollisionObject_None:未知,CollisionObject_Curb:路缘,CollisionObject_Pillar:柱子,CollisionObject_Wall:墙,CollisionObject_Bicycle:自行车,CollisionObject_Bush:灌木丛,CollisionObject_Cone:锥桶,CollisionObject_Reserved1:保留1,CollisionObject_Parklock:停车锁,CollisionObject_GeneralHigh:一般高物体,CollisionObject_Freespace:可行驶区域 */
    forward_collision_object TEXT, -- [未测试] '按照预测轨迹,前方障碍物类别.'
    backward_collision_object TEXT, -- [未测试] '按照预测轨迹,后方障碍物类别'
    direct_forward_collision_object TEXT, -- [未测试] '前方障碍物类别'
    direct_backward_collision_object TEXT, -- [未测试] '后方障碍物类别'
    left_collision_object TEXT, -- [未测试] '左侧障碍物类别'
    right_collision_object TEXT, -- [未测试] '右侧障碍物类别'
    forward_collision_motion_status TEXT, -- [未测试] '按照预测轨迹,前方障碍物运动状态. 枚举内容:STATUS_MOVING:运动,STATUS_STATIC:静止,STATUS_UNDEFINED:无法判断 '
    backward_collision_motion_status TEXT, -- [未测试] '按照预测轨迹,后方障碍物运动状态. 枚举内容:STATUS_MOVING:运动,STATUS_STATIC:静止,STATUS_UNDEFINED:无法判断 '
    direct_forward_collision_motion_status TEXT, -- [未测试] '前方障碍物运动状态. 枚举内容:STATUS_MOVING:运动,STATUS_STATIC:静止,STATUS_UNDEFINED:无法判断 '
    direct_backward_collision_motion_status TEXT, -- [未测试] '后方障碍物运动状态. 枚举内容:STATUS_MOVING:运动,STATUS_STATIC:静止,STATUS_UNDEFINED:无法判断 '
    left_collision_motion_status TEXT, -- [未测试] '左侧障碍物运动状态. 枚举内容:STATUS_MOVING:运动,STATUS_STATIC:静止,STATUS_UNDEFINED:无法判断 '
    right_collision_motion_status TEXT, -- [未测试] '右侧障碍物运动状态. 枚举内容:STATUS_MOVING:运动,STATUS_STATIC:静止,STATUS_UNDEFINED:无法判断 '
    feature_status TEXT, -- [未测试] '述停车系统状态及相应操作阶段 枚举内容:PARKINGFEATURE_Standby:停车系统待机、未激活或等指令,PARKINGFEATURE_Search:搜索车位,PARKINGFEATURE_GuidanceActive:引导停车,PARKINGFEATURE_Finish:停车完成,PARKINGFEATURE_Preguidance:处于引导前的准备阶段, PARKINGFEATURE_Fault:停车系统故障, PARKINGFEATURE_Suspend:停车暂停, PARKINGFEATURE_Irreversible_Abort:停车不可逆中止, PARKINGFEATURE_TakeOver_Abort:用户接管中止停车, PARKINGFEATURE_RemotePrepare:远程停车准备'
    parking_status TEXT, -- [测试通过] '泊车状态。 self_parking:自动泊车, manual_parking:手动泊车, other:非泊车态'
    park_start_timestamp INT, -- [测试通过] 单位为秒 当车为P档，并且iou大于0.75时计算
    park_end_timestamp INT -- [测试通过] 单位为秒 当车为P档，并且iou大于0.75时计算
);
DROP TABLE IF EXISTS cdm_model;
CREATE TABLE IF NOT EXISTS cdm_model (
    timestamp INT PRIMARY KEY, -- [未测试] '时间戳' 秒级
    ptp_ts INT, -- [未测试] '时间戳' 纳秒级
    frame_descriptor_scores TEXT, -- [未测试] '帧描述得分'
    model_name TEXT, -- [未测试] '模型名称'
    sensor_id INT, -- [未测试] '传感器ID'
    sensor_ts INT, -- [未测试] '传感器时间戳'
    counter INT, -- [未测试] '计数器'
    extend_info_keys TEXT -- [未测试] '扩展信息'
);

DROP TABLE IF EXISTS cdm_model_object_2d;
CREATE TABLE IF NOT EXISTS cdm_model_object_2d (
    timestamp INT, -- [未测试] '时间戳' 秒级
    model_name TEXT, -- [未测试] '模型名称'
    object_2d_score FLOAT, -- [未测试] '2D物体得分'
    object_2d_sub_score FLOAT, -- [未测试] '2D物体子得分'
    object_2d_cid INT, -- [未测试] 
    object_2d_sub_cid INT, -- [未测试] 
    object_2d_x_min FLOAT, -- [未测试] 
    object_2d_y_min FLOAT, -- [未测试] 
    object_2d_x_max FLOAT, -- [未测试] 
    object_2d_y_max FLOAT, -- [未测试] 
    object_2d_x_avg FLOAT, -- [未测试] 
    object_2d_y_avg FLOAT -- [未测试]
);

DROP TABLE IF EXISTS dynamic_dense_tags;
CREATE TABLE IF NOT EXISTS dynamic_dense_tags (
    timestamp INT, -- [未测试] '时间戳' 秒级
    tag_name TEXT, -- [未测试] '标签名称'
    tag_value_num FLOAT, -- [未测试] '数值标签Value'
    tag_value_enum TEXT, -- [未测试] '枚举标签Value'
    tag_value_json TEXT, -- [未测试] 'json标签Value'
    PRIMARY KEY (timestamp, tag_name)
);

DROP TABLE IF EXISTS sparse_tags;
CREATE TABLE IF NOT EXISTS sparse_tags ( -- ##警告## 如果sql中使用了sparse_tags表，一定要 select uuid, start_timestamp, end_timestamp 这几列
    uuid TEXT PRIMARY KEY,  -- [s-测试通过] 'uuid'
    tag_id INT,  -- [s-测试通过] 'tag_id'
    tag_name TEXT,  -- [s-测试通过] 'tag_name'
    tag_score FLOAT,   -- [s-测试通过] '置信度'
    start_ptp_ts INT,  -- [s-测试通过] '事件起始的ptp时间,单位ns'
    end_ptp_ts INT,  -- [s-测试通过] '事件结束的ptp时间,单位ns'
    start_utc_ts INT,  -- [s-测试通过] '事件起始的utc时间,单位ns'
    end_utc_ts INT, -- [s-测试通过] '事件结束的utc时间,单位ns'
    tag_detail TEXT, -- [s-不推荐使用] '该信息在属性列中存储'
    start_timestamp INT, -- [s-测试通过] '事件起始的ptp时间,单位s'
    end_timestamp INT, -- [s-测试通过] '事件结束的ptp时间,单位s'
    duration INT, -- [s-测试通过] '事件持续的时长,单位s'
    vdm_name TEXT, -- [s-不推荐使用] 
    vdm_version TEXT, -- [s-不推荐使用] 
    interactive_obj_id INT, -- [s-不推荐使用] '该信息在属性列中存储'
    attr1 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr2 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr3 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr4 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr5 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr6 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr7 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr8 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr9 TEXT, -- [s-测试通过] '含义在后文根据tag_name而确定'
    attr10 TEXT -- [s-测试通过] '含义在后文根据tag_name而确定'
    );
CREATE INDEX tag_name_index ON sparse_tags (tag_name);

/*
sparse_tags 不同tag_name下attr1--attr10的具体含义
tag_name=lanechange 自车换道 [t-测试通过]
    start_ptp_ts为自车换道前在车道中间的时间，最长不超过7s
    end_ptp_ts为自车换道后在车道中间的时间，最长不超过7s
    attr1: [a-测试通过] '字段含义:lanechange_ts: 自车后轮压过换道车道线的时间'
    attr2: [a-测试通过] '字段含义:pre_following: 换道前跟行目标ID(对应obj表里的id)'
    attr3: [a-测试通过] '字段含义:post_following: 换道后跟行目标ID(对应obj表里的id)'
    attr4: [a-测试通过] '字段含义:direction(换道方向); 枚举内容:left:左换道,right:右换道 '
    attr5: [a-未测试] '字段含义:line_color(换道跨越的车道线颜色); 枚举内容:LDColor_Unknown:未知,LDColor_White:白色,LDColor_Yellow:黄色,LDColor_Orange:橘色,LDColor_Blue:蓝色,LDColor_Others:其他颜色,LDColor_Green:绿色,LDColor_Yellow_White:黄白色,LDColor_White_Yellow:白黄色'
    attr6: [a-未测试] '字段含义:line_type(换道跨越的车道线类型); 枚举内容:LDType_Unknown:未知,,LDType_Solid:实线,,LDType_Dash:虚线,LDType_Solid_Dash:实虚线,LDType_Dash_Solid:虚实线,LDType_Solid_Solid:双实线,LDType_Deceleration_Dash:减速虚线,LDType_Deceleration_Solid:减速实线,LDType_Guide:导流线,LDType_Dash_Dash:双虚线,LDType_Direct:可变导向线,LDType_Solid_Four:四实线'
    attr7: [a-未测试] '字段含义:pre_lane_centering(换道前处于车道保持); 枚举内容:1;0'
    attr8: [a-未测试] '字段含义:post_lane_centering(换道后处于车道保持); 枚举内容:1;0'

tag_name=junction 自车处于路口 [t-测试通过]
    start_ptp_ts为自车进入路口停止线时刻的时间
    end_ptp_ts为自车经过路口后进入稳定车道的时间
    attr1: [a-测试通过] '字段含义:direction(行进方向); 枚举内容:straight:直行,left:左转,right:右转,uturn:掉头'
    attr2: [a-未测试] '字段含义:type(路口类型); 枚举内容: crossing:十字路口'
    attr3: [a-不通过,准确率60%]'字段含义:have_tld(是否有红绿灯); 枚举内容: 1:有,0:没有 '
    attr4: [a-不通过,小路口准确率70%]'字段含义:range(路口大小); 枚举内容: small:小,medium:中,large:大'

tag_name=obj_interaction 目标交互 [t-测试通过]
    start_ptp_ts为交互开始时间
    end_ptp_ts为交互结束时间
    attr1: [a-测试通过,只有cutin,cutout,parallel准，其他不准] '字段含义:interaction_type; 枚举内容:cutin:目标驶入自车前方;cutout:目标从自车前方驶离;crossing:目标横穿;react:自车对目标横向响应;game:自车和目标博弈;parallel:自车和目标近距离平行;nudge:自车绕行目标'
    attr2: [a-测试通过] '字段含义:interaction_obj_id(交互的目标id,和obj表的id对应) 与obj.id join 的时候需要从string 转成int类型，cast( x as int) '

tag_name=ego_merge 自车汇入 [t-未开发]
    start_ptp_ts为开始汇入时间
    end_ptp_ts为全车汇入车道中间时间
    attr1: [a-未测试] '字段含义:target_lane_obj_ids 汇入车道的objid集合'

tag_name=ego_split 自车分流 [t-未开发]
    start_ptp_ts为开始驶出时间
    end_ptp_ts为全车汇入车道中间时间
    attr1: [a-未测试] '字段含义:target_lane_obj_ids 汇入车道的objid集合'

tag_name=ego_longitudinal [t-测试通过]
    start_ptp_ts为自车行为开始时间
    end_ptp_ts为自车行为结束时间
    attr1: [a-测试通过] '字段含义:type(自车纵向行为类型); 枚举内容为：stop：刹停，start：起步，follow：跟行'
    attr2: [a-测试通过] '字段含义:following_id(跟行目标id，可以为空)'

tag_name=parking 泊车标签 [t-测试通过]
    start_ptp_ts为泊车开始时间
    end_ptp_ts为泊车结束时间
    attr1: [a-未测试] '字段含义:(泊车status); 枚举内容:self-parking:自动泊车; manual_parking:人工泊车'
    attr2: [a-测试通过] '字段含义:车位类型; 枚举内容:1:LeftParallelParkIn;2:RightParallelParkIn;3:LeftCrossParkIn;4:RightCrossParkIn;7:LeftAngledParkIn;8:RightAngledParkIn'
    attr3: [a-测试通过] '字段含义:(窄车位);枚举内容:true;false'
    attr4: [a-测试通过] '字段含义:(窄通道);枚举内容:true;false'
    attr5: [a-测试通过] '字段含义:(断头路);枚举内容:true;false'

tag_name=upward_slope 上坡标签 [t-测试通过]
    start_ptp_ts为上坡开始时间
    end_ptp_ts为上坡结束时间
    attr1: [a-未测试] '字段含义:坡度'
    attr2: [a-未测试] '字段含义:坡长'
    attr3: [a-未测试] '字段含义:坡高'
    attr4: [a-测试通过] '字段含义:上坡持续时长'

tag_name=downward_slope 下坡标签 [t-测试通过]
    start_ptp_ts为下坡开始时间
    end_ptp_ts为下坡结束时间
    attr1: [a-未测试] '字段含义:坡度'
    attr2: [a-未测试] '字段含义:坡长'
    attr3: [a-未测试] '字段含义:坡高'
    attr4: [a-测试通过] '字段含义:下坡持续时长'

tag_name=turnleft_waiting_area 左转待转区标签 [t-测试通过]
    start_ptp_t为自车驶入左转待转区前3s
    end_ptp_ts为自车驶离左转待转区后7s
    attr1: [a-测试通过] '字段含义:自车在左转待转区静止等待开始ptp时间'
    attr2: [a-测试通过] '字段含义:自车驶离左转待转区ptp时间'

tag_name=narrow_road 小路 [t-待测试]
    start_ptp_ts为当前时刻行驶道路为小路
    end_ptp_ts为start_ptp_ts+1s

tag_name=curved_road 弯道 [t-待测试]
    start_ptp_ts为进入弯道时间
    end_ptp_ts为驶出弯道时间
    attr1:[a-未测试] '字段含义:弯道类型 Stype为S型弯道，Rightangle为直角弯，Null为其他类型弯道'

tag_name=VRU_cross_zebra VRU过斑马线标签 [t-测试通过]
    start_ptp_ts为VRU到达斑马线前3s
    end_ptp_ts为VRU在斑马线前运动至少6米后7s
    attr1: [a-未测试] '字段含义:crossing'

tag_name=fft_urban.sidepass.congestion 城区自车换道后目标车道拥堵 [t-未测试]
tag_name=fft_hw.sidepass.congestion  高快自车换道后目标车道拥堵 [t-未测试]
tag_name=fft_urban.sidepass.navi_lc_congestion_intersection 城区路口前拥堵导航换道 [t-未测试]
tag_name=fft_hw.sidepass.navi_lc_congestion_intersection 高快路口前拥堵导航换道 [t-未测试]
tag_name=fft_urban.sidepass.lanechange 城区换道 [t-未测试]
tag_name=fft_hw.sidepass.lanechange 高快换道 [t-未测试]
tag_name=fft_urban.sidepass.lanechange_left 城区左换道 [t-未测试]
tag_name=fft_hw.sidepass.lanechange_left 高快左换道 [t-未测试]
tag_name=fft_urban.sidepass.lanechange_right 城区右换道 [t-未测试]
tag_name=fft_hw.sidepass.lanechange_right 高快右换道 [t-未测试]
tag_name=fft_urban.sidepass.overtake 城区超车换道 [t-未测试]
tag_name=fft_hw.sidepass.overtake 高快超车换道 [t-未测试]
tag_name=fft_urban.sidepass.stationary_OD_avoidance 城区静止目标避障换道 [t-未测试]
tag_name=fft_hw.sidepass.stationary_OD_avoidance 高快静止目标避障换道 [t-未测试]
tag_name=fft_urban.sidepass.navigate 城区导航换道 [t-未测试]
tag_name=fft_hw.sidepass.navigate 高快导航换道 [t-未测试]
tag_name=fft_urban.sidepass.slow_target_al_front 城区换道后车道有慢速目标 [t-未测试]
tag_name=fft_hw.sidepass.slow_target_al_front 高快换道后车道有慢速目标 [t-未测试]
*/


-- 提到两个限制条件有先后顺序的时候，可以使用语法,如对于需要统计中间连续每一秒的可以用 t1 JOIN e2 ON t1.timestamp BETWEEN e2.timestamp - 5 AND e2.timestamp;  对于只需要孤立两个时间点的可以用t1 JOIN e2 ON t1.timestamp = e2.timestamp - 5 
-- 自车在路口的信息，优先使用sparse_tags 表中tag_name=junction来进行判断
