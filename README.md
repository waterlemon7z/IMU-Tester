# IMU_tester
Author : MinSeok Choi (waterlemon7z)   
Last Commit : 2024.04.02   
An IMU sensors' tester with flutter   

## Requirements
- Android / iOS phones
- Minimum Android SDK version 25

## Features
- Check IMU sensors' values
- Can choose which sensor would be displayed by chart
- Export file by csv (Normally /sdcard/Android/data/com.waterlemon7z.imu_tester/files/2024-xx-xx...csv)
- Check user's step counts

## Issues
- Pedometer sensor starts late (멈춰있는 상태에서 start를 누르고 걷기를 시작하면 초가 올라감에도 불구하고 걸음수는 가만히 있다가 대략 7걸음 뒤에 카운팅이 시작됨.)