// Available syscalls for mips64-android.
// This file is autogenerated by the genandroidsyscalls.py script. 
// Script location: https://svn.freepascal.org/svn/fpcbuild/scripts/android

const
  syscall_nr_read = 5000;
  syscall_nr_write = 5001;
  syscall_nr_close = 5003;
  syscall_nr_fstat = 5005;
  syscall_nr_fstat64 = syscall_nr_fstat;
  syscall_nr_lseek = 5008;
  syscall_nr_mmap = 5009;
  syscall_nr_mmap64 = syscall_nr_mmap;
  syscall_nr_mprotect = 5010;
  syscall_nr_munmap = 5011;
  syscall_nr_brk = 5012;
  syscall_nr_rt_sigaction = 5013;
  syscall_nr_rt_sigprocmask = 5014;
  syscall_nr_ioctl = 5015;
  syscall_nr_pread64 = 5016;
  syscall_nr_pwrite64 = 5017;
  syscall_nr_readv = 5018;
  syscall_nr_writev = 5019;
  syscall_nr_sched_yield = 5023;
  syscall_nr_mremap = 5024;
  syscall_nr_msync = 5025;
  syscall_nr_mincore = 5026;
  syscall_nr_madvise = 5027;
  syscall_nr_dup = 5031;
  syscall_nr_nanosleep = 5034;
  syscall_nr_getitimer = 5035;
  syscall_nr_setitimer = 5036;
  syscall_nr_getpid = 5038;
  syscall_nr_sendfile = 5039;
  syscall_nr_socket = 5040;
  syscall_nr_connect = 5041;
  syscall_nr_sendto = 5043;
  syscall_nr_recvfrom = 5044;
  syscall_nr_sendmsg = 5045;
  syscall_nr_recvmsg = 5046;
  syscall_nr_shutdown = 5047;
  syscall_nr_bind = 5048;
  syscall_nr_listen = 5049;
  syscall_nr_getsockname = 5050;
  syscall_nr_getpeername = 5051;
  syscall_nr_socketpair = 5052;
  syscall_nr_setsockopt = 5053;
  syscall_nr_getsockopt = 5054;
  syscall_nr_clone = 5055;
  syscall_nr_execve = 5057;
  syscall_nr_exit = 5058;
  syscall_nr_wait4 = 5059;
  syscall_nr_kill = 5060;
  syscall_nr_uname = 5061;
  syscall_nr_fcntl = 5070;
  syscall_nr_flock = 5071;
  syscall_nr_fsync = 5072;
  syscall_nr_fdatasync = 5073;
  syscall_nr_truncate = 5074;
  syscall_nr_ftruncate = 5075;
  syscall_nr_ftruncate64 = syscall_nr_ftruncate;
  syscall_nr_getcwd = 5077;
  syscall_nr_chdir = 5078;
  syscall_nr_fchdir = 5079;
  syscall_nr_fchmod = 5089;
  syscall_nr_fchown = 5091;
  syscall_nr_umask = 5093;
  syscall_nr_gettimeofday = 5094;
  syscall_nr_getrlimit = 5095;
  syscall_nr_getrusage = 5096;
  syscall_nr_sysinfo = 5097;
  syscall_nr_times = 5098;
  syscall_nr_ptrace = 5099;
  syscall_nr_getuid = 5100;
  syscall_nr_getgid = 5102;
  syscall_nr_geteuid = 5105;
  syscall_nr_getegid = 5106;
  syscall_nr_setpgid = 5107;
  syscall_nr_getppid = 5108;
  syscall_nr_setsid = 5110;
  syscall_nr_setregid = 5112;
  syscall_nr_getgroups = 5113;
  syscall_nr_setresuid = 5115;
  syscall_nr_getresuid = 5116;
  syscall_nr_getresgid = 5118;
  syscall_nr_getpgid = 5119;
  syscall_nr_getsid = 5122;
  syscall_nr_capget = 5123;
  syscall_nr_capset = 5124;
  syscall_nr_rt_sigpending = 5125;
  syscall_nr_rt_sigtimedwait = 5126;
  syscall_nr_rt_sigqueueinfo = 5127;
  syscall_nr_rt_sigsuspend = 5128;
  syscall_nr_sigaltstack = 5129;
  syscall_nr_personality = 5132;
  syscall_nr_statfs = 5134;
  syscall_nr_fstatfs = 5135;
  syscall_nr_getpriority = 5137;
  syscall_nr_setpriority = 5138;
  syscall_nr_sched_setparam = 5139;
  syscall_nr_sched_getparam = 5140;
  syscall_nr_sched_setscheduler = 5141;
  syscall_nr_sched_getscheduler = 5142;
  syscall_nr_sched_get_priority_max = 5143;
  syscall_nr_sched_get_priority_min = 5144;
  syscall_nr_sched_rr_get_interval = 5145;
  syscall_nr_mlock = 5146;
  syscall_nr_munlock = 5147;
  syscall_nr_mlockall = 5148;
  syscall_nr_munlockall = 5149;
  syscall_nr_pivot_root = 5151;
  syscall_nr_prctl = 5153;
  syscall_nr_setrlimit = 5155;
  syscall_nr_sync = 5157;
  syscall_nr_quotactl = 5172;
  syscall_nr_gettid = 5178;
  syscall_nr_readahead = 5179;
  syscall_nr_setxattr = 5180;
  syscall_nr_lsetxattr = 5181;
  syscall_nr_fsetxattr = 5182;
  syscall_nr_getxattr = 5183;
  syscall_nr_lgetxattr = 5184;
  syscall_nr_fgetxattr = 5185;
  syscall_nr_listxattr = 5186;
  syscall_nr_llistxattr = 5187;
  syscall_nr_flistxattr = 5188;
  syscall_nr_removexattr = 5189;
  syscall_nr_lremovexattr = 5190;
  syscall_nr_fremovexattr = 5191;
  syscall_nr_tkill = 5192;
  syscall_nr_futex = 5194;
  syscall_nr_sched_setaffinity = 5195;
  syscall_nr_sched_getaffinity = 5196;
  syscall_nr_cacheflush = 5197;
  syscall_nr_io_setup = 5200;
  syscall_nr_io_destroy = 5201;
  syscall_nr_io_getevents = 5202;
  syscall_nr_io_submit = 5203;
  syscall_nr_io_cancel = 5204;
  syscall_nr_exit_group = 5205;
  syscall_nr_epoll_ctl = 5208;
  syscall_nr_rt_sigreturn = 5211;
  syscall_nr_set_tid_address = 5212;
  syscall_nr_restart_syscall = 5213;
  syscall_nr_fadvise64 = 5215;
  syscall_nr_timer_create = 5216;
  syscall_nr_timer_settime = 5217;
  syscall_nr_timer_gettime = 5218;
  syscall_nr_timer_getoverrun = 5219;
  syscall_nr_timer_delete = 5220;
  syscall_nr_clock_gettime = 5222;
  syscall_nr_clock_getres = 5223;
  syscall_nr_clock_nanosleep = 5224;
  syscall_nr_tgkill = 5225;
  syscall_nr_waitid = 5237;
  syscall_nr_set_thread_area = 5242;
  syscall_nr_inotify_add_watch = 5244;
  syscall_nr_inotify_rm_watch = 5245;
  syscall_nr_openat = 5247;
  syscall_nr_mkdirat = 5248;
  syscall_nr_mknodat = 5249;
  syscall_nr_fchownat = 5250;
  syscall_nr_newfstatat = 5252;
  syscall_nr_fstatat = syscall_nr_newfstatat;
  syscall_nr_fstatat64 = syscall_nr_newfstatat;
  syscall_nr_unlinkat = 5253;
  syscall_nr_renameat = 5254;
  syscall_nr_linkat = 5255;
  syscall_nr_symlinkat = 5256;
  syscall_nr_readlinkat = 5257;
  syscall_nr_fchmodat = 5258;
  syscall_nr_faccessat = 5259;
  syscall_nr_pselect6 = 5260;
  syscall_nr_ppoll = 5261;
  syscall_nr_unshare = 5262;
  syscall_nr_splice = 5263;
  syscall_nr_sync_file_range = 5264;
  syscall_nr_tee = 5265;
  syscall_nr_vmsplice = 5266;
  syscall_nr_getcpu = 5271;
  syscall_nr_epoll_pwait = 5272;
  syscall_nr_ioprio_set = 5273;
  syscall_nr_ioprio_get = 5274;
  syscall_nr_utimensat = 5275;
  syscall_nr_fallocate = 5279;
  syscall_nr_fallocate64 = syscall_nr_fallocate;
  syscall_nr_timerfd_create = 5280;
  syscall_nr_timerfd_gettime = 5281;
  syscall_nr_timerfd_settime = 5282;
  syscall_nr_signalfd4 = 5283;
  syscall_nr_eventfd2 = 5284;
  syscall_nr_eventfd = syscall_nr_eventfd2;
  syscall_nr_epoll_create1 = 5285;
  syscall_nr_dup3 = 5286;
  syscall_nr_pipe2 = 5287;
  syscall_nr_inotify_init1 = 5288;
  syscall_nr_preadv = 5289;
  syscall_nr_pwritev = 5290;
  syscall_nr_rt_tgsigqueueinfo = 5291;
  syscall_nr_perf_event_open = 5292;
  syscall_nr_accept4 = 5293;
  syscall_nr_recvmmsg = 5294;
  syscall_nr_prlimit64 = 5297;
  syscall_nr_prlimit = syscall_nr_prlimit64;
  syscall_nr_syncfs = 5301;
  syscall_nr_sendmmsg = 5302;
  syscall_nr_setns = 5303;
  syscall_nr_process_vm_readv = 5304;
  syscall_nr_process_vm_writev = 5305;
  syscall_nr_getdents64 = 5308;
  syscall_nr_sched_setattr = 5309;
  syscall_nr_sched_getattr = 5310;
  syscall_nr_renameat2 = 5311;
  syscall_nr_seccomp = 5312;
  syscall_nr_getrandom = 5313;
  syscall_nr_memfd_create = 5314;
  syscall_nr_execveat = 5316;
  syscall_nr_mlock2 = 5319;
  syscall_nr_copy_file_range = 5320;
  syscall_nr_preadv2 = 5321;
  syscall_nr_pwritev2 = 5322;
  syscall_nr_statx = 5330;

// The following syscalls are blocked by SECCOMP starting from Android 8.
// Do not use them, unless you know what you are doing.
const
  syscall_nr_syslog = 5101 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_klogctl = 5101 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setuid = 5103 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setgid = 5104 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setreuid = 5111 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setgroups = 5114 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setresgid = 5117 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setfsuid = 5120 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setfsgid = 5121 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_adjtimex = 5154 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_chroot = 5156 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_acct = 5158 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_settimeofday = 5159 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_mount = 5160 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_umount2 = 5161 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_swapon = 5162 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_swapoff = 5163 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_reboot = 5164 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_sethostname = 5165 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_setdomainname = 5166 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_init_module = 5168 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_delete_module = 5169 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_clock_settime = 5221 deprecated 'This syscall is blocked on Android 8+';
  syscall_nr_clock_adjtime = 5300 deprecated 'This syscall is blocked on Android 8+';