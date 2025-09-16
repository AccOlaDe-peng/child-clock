import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
          shape: CircleBorder(),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
          shape: CircleBorder(),
        ),
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
  int _customMinutes = 0;
  int _customSeconds = 0;
  
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              icon: Icon(MdiIcons.clockOutline),
              selectedIcon: Icon(MdiIcons.clock, color: Colors.blue.shade600),
              label: '时钟',
            ),
            NavigationDestination(
              icon: Icon(MdiIcons.timerOutline),
              selectedIcon: Icon(MdiIcons.timer, color: Colors.blue.shade600),
              label: '定时',
            ),
            NavigationDestination(
              icon: Icon(MdiIcons.cogOutline),
              selectedIcon: Icon(MdiIcons.cog, color: Colors.blue.shade600),
              label: '设置',
            ),
          ],
        ),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '100%',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 20),
            
            // 主时钟显示
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 时间显示 - 添加动画效果
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _formatTime(_currentTime),
                            style: GoogleFonts.robotoMono(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                          // 上午/下午标识
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _getAmPm(_currentTime),
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(),
                  
                  const SizedBox(height: 40),
                  
                  // 日期和星期信息
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 闹钟信息
                          Row(
                            children: [
                              Icon(
                                MdiIcons.alarmCheck,
                                color: Colors.orange.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '3天 上午 20:00',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          Container(
                            height: 24,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          
                          // 日期和星期
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.calendarMonth,
                                    color: Colors.blue.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(_currentTime),
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatWeekday(_currentTime),
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.battery_full,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '100%',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 40),
            
            // 倒计时显示
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 圆形进度条 - 按照图片设计，美化样式
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 外层装饰圆环
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.grey.shade100,
                              ],
                              stops: const [0.7, 1.0],
                            ),
                          ),
                        ),
                        // 背景圆环 - 浅灰色
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 16,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                          ),
                        ),
                        // 进度圆环 - 红色渐变，按照图片样式
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: CircularProgressIndicator(
                            value: _totalCountdownSeconds > 0 ? (_totalCountdownSeconds - _countdownSeconds) / _totalCountdownSeconds : 0.0,
                            strokeWidth: 16,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _countdownSeconds > 0 ? Colors.red : Colors.grey.shade400,
                            ),
                          ),
                        ),
                        // 中心时间显示 - 大字体，黑色，时钟样式
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 时间显示 - 时钟样式
                              Text(
                                _formatCountdownTime(_countdownSeconds),
                                style: GoogleFonts.robotoMono(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // 沙漏图标
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  MdiIcons.timerSand,
                                  color: Colors.red.shade600,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // 状态文字
                              Text(
                                _isCountdownRunning 
                                    ? (_isCountdownPaused ? '已暂停' : '倒计时中')
                                    : '准备就绪',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(),
                  
                  const SizedBox(height: 40),
                  
                  // 控制按钮
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isCountdownRunning ? null : _startCountdown,
                            icon: Icon(MdiIcons.play),
                            label: const Text('开始'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isCountdownRunning ? _pauseCountdown : null,
                            icon: Icon(_isCountdownPaused ? MdiIcons.play : MdiIcons.pause),
                            label: Text(_isCountdownPaused ? '继续' : '暂停'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isCountdownRunning ? _stopCountdown : null,
                            icon: Icon(MdiIcons.stop),
                            label: const Text('停止'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  // 时间设置按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 快速设置按钮
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _setCountdownTime,
                          icon: Icon(MdiIcons.clockTimeEight),
                          label: const Text('快速设置'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 自定义时间设置按钮
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showCustomTimeDialog,
                          icon: Icon(MdiIcons.clockEdit),
                          label: const Text('自定义时间'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
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
        title: Row(
          children: [
            Icon(MdiIcons.timer, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text('设置倒计时时间'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '请选择倒计时时间（最多1小时）：',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildTimeButton('5分钟', 5 * 60),
                _buildTimeButton('10分钟', 10 * 60),
                _buildTimeButton('15分钟', 15 * 60),
                _buildTimeButton('20分钟', 20 * 60),
                _buildTimeButton('30分钟', 30 * 60),
                _buildTimeButton('45分钟', 45 * 60),
                _buildTimeButton('1小时', 60 * 60),
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

  void _showCustomTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(MdiIcons.clockEdit, color: Colors.purple.shade600),
                  const SizedBox(width: 8),
                  const Text('自定义时间'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '设置自定义倒计时时间（最多1小时）：',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '分钟',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                value: _customMinutes,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: List.generate(61, (index) => index)
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _customMinutes = value ?? 0;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '秒',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                value: _customSeconds,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: List.generate(60, (index) => index)
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text('$value'),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _customSeconds = value ?? 0;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(MdiIcons.information, color: Colors.blue.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '总时间：${_formatCountdownTime(_customMinutes * 60 + _customSeconds)}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final totalSeconds = _customMinutes * 60 + _customSeconds;
                    if (totalSeconds > 0 && totalSeconds <= 3600) { // 限制最大1小时
                      setState(() {
                        _countdownSeconds = totalSeconds;
                        _totalCountdownSeconds = totalSeconds;
                        _isCountdownRunning = false;
                        _isCountdownPaused = false;
                      });
                      Navigator.of(context).pop();
                    } else if (totalSeconds > 3600) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('倒计时时间不能超过1小时'),
                          backgroundColor: Colors.red.shade600,
                        ),
                      );
                    }
                  },
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
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