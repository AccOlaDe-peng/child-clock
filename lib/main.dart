import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ChildClockApp());
}

class ChildClockApp extends StatelessWidget {
  const ChildClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '儿童时钟',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'monospace', // 使用等宽字体模拟数字时钟
      ),
      home: const MainClockPage(),
    );
  }
}

class MainClockPage extends StatefulWidget {
  const MainClockPage({super.key});

  @override
  State<MainClockPage> createState() => _MainClockPageState();
}

class _MainClockPageState extends State<MainClockPage> {
  int _currentIndex = 0;
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  
  // 倒计时相关变量
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  int _totalCountdownSeconds = 0;
  bool _isCountdownRunning = false;
  bool _isCountdownPaused = false;
  
  // 闹钟相关变量
  TimeOfDay _alarmTime = const TimeOfDay(hour: 20, minute: 0);
  bool _alarmEnabled = true;
  int _alarmDays = 3; // 3天后
  
  // 设置相关变量
  bool _is24HourFormat = false;
  String _language = '中文';
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        _checkAlarm();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  void _checkAlarm() {
    if (_alarmEnabled) {
      final now = DateTime.now();
      final alarmDateTime = DateTime(now.year, now.month, now.day, _alarmTime.hour, _alarmTime.minute);
      
      if (now.hour == _alarmTime.hour && now.minute == _alarmTime.minute && now.second == 0) {
        _showAlarmDialog();
      }
    }
  }
  
  void _showAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⏰ 闹钟响了！'),
        content: const Text('该起床了！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD), // 浅蓝色背景
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainClockInterface(),
          _buildCountdownInterface(),
          _buildSettingsInterface(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: '时钟',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: '定时',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }

  Widget _buildMainClockInterface() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 电池图标
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.battery_full,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 主时钟显示
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 时间显示
                  Text(
                    _formatTime(_currentTime),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'monospace',
                    ),
                  ),
                  
                  // 上午/下午标识
                  Text(
                    _getAmPm(_currentTime),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 日期和星期信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 闹钟信息
                      Row(
                        children: [
                          Icon(
                            Icons.alarm,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '3天 上午 20:00',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      
                      // 日期
                      Text(
                        _formatDate(_currentTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      
                      // 星期
                      Text(
                        _formatWeekday(_currentTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownInterface() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 电池图标
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.battery_full,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // 倒计时显示
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 圆形进度条
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        // 背景圆环
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                        ),
                        // 进度圆环
                        CircularProgressIndicator(
                          value: _totalCountdownSeconds > 0 ? _countdownSeconds / _totalCountdownSeconds : 0.0,
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        // 中心时间显示
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatCountdownTime(_countdownSeconds),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(
                                _isCountdownRunning ? Icons.hourglass_bottom : Icons.hourglass_empty,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 控制按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isCountdownRunning ? null : _startCountdown,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('开始'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isCountdownRunning ? _pauseCountdown : null,
                        icon: Icon(_isCountdownPaused ? Icons.play_arrow : Icons.pause),
                        label: Text(_isCountdownPaused ? '继续' : '暂停'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isCountdownRunning ? _stopCountdown : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('停止'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 设置倒计时时间按钮
                  ElevatedButton.icon(
                    onPressed: _setCountdownTime,
                    icon: const Icon(Icons.timer),
                    label: const Text('设置时间'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsInterface() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 电池图标
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.battery_full,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 设置标题
            const Text(
              '时间设置',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 设置选项
            Expanded(
              child: ListView(
                children: [
                  _buildSettingItem(
                    icon: Icons.alarm,
                    title: '闹钟设置',
                    subtitle: '${_alarmTime.format(context)} (${_alarmDays}天后)',
                    onTap: _setAlarmTime,
                  ),
                  _buildSettingItem(
                    icon: Icons.timer,
                    title: '定时器设置',
                    subtitle: '设置倒计时时间',
                    onTap: _setCountdownTime,
                  ),
                  _buildSettingItem(
                    icon: Icons.schedule,
                    title: '时间格式',
                    subtitle: _is24HourFormat ? '24小时制' : '12小时制',
                    onTap: _toggleTimeFormat,
                  ),
                  _buildSettingItem(
                    icon: Icons.language,
                    title: '语言设置',
                    subtitle: _language,
                    onTap: _setLanguage,
                  ),
                  _buildSettingItem(
                    icon: Icons.palette,
                    title: '主题设置',
                    subtitle: _isDarkTheme ? '深色主题' : '浅色主题',
                    onTap: _toggleTheme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade600),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getAmPm(DateTime time) {
    return time.hour < 12 ? '上午' : '下午';
  }

  String _formatDate(DateTime time) {
    return '${time.month}/${time.day}';
  }

  String _formatWeekday(DateTime time) {
    const weekdays = [
      '星期1', '星期2', '星期3', '星期4', '星期5', '星期6', '星期日'
    ];
    return weekdays[time.weekday - 1];
  }
  
  // 倒计时相关方法
  String _formatCountdownTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  void _startCountdown() {
    if (_countdownSeconds == 0) {
      _showCountdownTimeDialog();
      return;
    }
    
    setState(() {
      _isCountdownRunning = true;
      _isCountdownPaused = false;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _countdownFinished();
        }
      });
    });
  }
  
  void _pauseCountdown() {
    setState(() {
      _isCountdownPaused = !_isCountdownPaused;
    });
    
    if (_isCountdownPaused) {
      _countdownTimer?.cancel();
    } else {
      _startCountdown();
    }
  }
  
  void _stopCountdown() {
    setState(() {
      _isCountdownRunning = false;
      _isCountdownPaused = false;
      _countdownSeconds = 0;
      _totalCountdownSeconds = 0;
    });
    _countdownTimer?.cancel();
  }
  
  void _countdownFinished() {
    _stopCountdown();
    _showCountdownFinishedDialog();
  }
  
  void _showCountdownTimeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置倒计时时间'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请选择倒计时时间：'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeButton('5分钟', 5 * 60),
                _buildTimeButton('10分钟', 10 * 60),
                _buildTimeButton('15分钟', 15 * 60),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeButton('30分钟', 30 * 60),
                _buildTimeButton('1小时', 60 * 60),
                _buildTimeButton('2小时', 2 * 60 * 60),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimeButton(String label, int seconds) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _countdownSeconds = seconds;
          _totalCountdownSeconds = seconds;
        });
        Navigator.of(context).pop();
        _startCountdown();
      },
      child: Text(label),
    );
  }
  
  void _showCountdownFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⏰ 时间到！'),
        content: const Text('倒计时结束！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  void _setCountdownTime() {
    _showCountdownTimeDialog();
  }
  
  // 闹钟相关方法
  void _setAlarmTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _alarmTime,
    );
    
    if (picked != null) {
      setState(() {
        _alarmTime = picked;
      });
    }
  }
  
  // 设置相关方法
  void _toggleTimeFormat() {
    setState(() {
      _is24HourFormat = !_is24HourFormat;
    });
  }
  
  void _setLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('中文'),
              leading: Radio<String>(
                value: '中文',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'English',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }
}