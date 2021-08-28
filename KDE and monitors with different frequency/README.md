# KDE and monitors with different frequency
 The essence of the problem is that when connecting two or more monitors - their synchronization occurs at the minimum of the group.
 When connected 144Hz and 60Hz monitors, both will operate in 60Hz mode 

## Solution
  In the `/etc/enviroment` you need to add:
 ```
CLUTTER_DEFAULT_FPS=144
__GL_SYNC_DISPLAY_DEVICE=DP-2
 ```
 Where `144` - FPS, and `DP-2` - monitorID with the highest frequency. 
 Launch Nvidia X Server settings by typing `nvidia-settings` and then you disable `Allow Flipping` in the OpenGL menu.

### Related problem
  Notifications and shortcuts on the desktop react too quickly to actions. To fix in `kcmshell5 qtquickSettings` You must select a simple drawing cycle. 
  
  
# KDE и мониторы с разной частотой развёртки
 Суть проблемы заключается в том, что при подключении двух и более мониторов - их синхронизация происходит по минимальному из группы.
 Т.е. при подключении 144hz и 60hz мониторов оба будут работать в режиме 60hz
 
## Решение
 В файл `/etc/enviroment` необходимо добавить:
 ```
CLUTTER_DEFAULT_FPS=144
__GL_SYNC_DISPLAY_DEVICE=DP-2
 ```
 Где `144` - FPS монитора, а `DP-2` - ID монитора с наивысшей частотой.
 Запустите настройки NVIDIA X Server, набрав `nvidia-settings`, и отключите `Allow Flipping` в меню OpenGL. 
 
 ### Связанная проблема
 Уведомления и ярлыки на рабочем столе слишком быстро реагируют на действия. Для исправления в `kcmshell5 qtquicksettings` необходимо выбрать простой цикл отрисовки.
 
 # Источник / source
 https://bugs.kde.org/show_bug.cgi?id=419421
