/*
 * Copyright (c) 2023 Félix Poulin-Bélanger. All rights reserved.
 */

#ifndef dynamic_info_h
#define dynamic_info_h

struct dynamic_info {
    const char* kern_version;
    bool kread_kqueue_workloop_ctl_supported;
    bool perf_supported;
    // struct proc
    u64 proc__p_list__le_prev;
    u64 proc__p_pid;
    u64 proc__p_fd__fd_ofiles;
    u64 proc__object_size;
    // struct task
    u64 task__map;
    // struct thread
    u64 thread__thread_id;
    // kernelcache static addresses (perf)
    u64 kernelcache__cdevsw;                          // "spec_open type" or "Can't mark ptc as kqueue ok"
    u64 kernelcache__gPhysBase;                       // "%s: illegal PA: 0x%llx; phys base 0x%llx, size 0x%llx"
    u64 kernelcache__gPhysSize;                       // (gPhysBase + 0x8)
    u64 kernelcache__gVirtBase;                       // "%s: illegal PA: 0x%llx; phys base 0x%llx, size 0x%llx"
    u64 kernelcache__perfmon_dev_open;                // "perfmon: attempt to open unsupported source: 0x%x"
    u64 kernelcache__perfmon_devices;                 // "perfmon: %s: devfs_make_node_clone failed"
    u64 kernelcache__ptov_table;                      // "%s: illegal PA: 0x%llx; phys base 0x%llx, size 0x%llx"
    u64 kernelcache__vn_kqfilter;                     // "Invalid knote filter on a vnode!"
};

const struct dynamic_info kern_versions[] = {
    // iOS 16.5 - iPhone 14 Pro Max
    {
        .kern_version = "Darwin Kernel Version 22.5.0: Mon Apr 24 21:09:28 PDT 2023; root:xnu-8796.122.4~1/RELEASE_ARM64_T8120",
        .kread_kqueue_workloop_ctl_supported = false,
        .perf_supported = true,
        .proc__p_list__le_prev = 0x0008,
        .proc__p_pid = 0x0060,
        .proc__p_fd__fd_ofiles = 0x00f8,
        .proc__object_size = 0x0730,
        .task__map = 0x0028,
        .thread__thread_id = 0,
        .kernelcache__cdevsw = 0xfffffff00a419208,
        .kernelcache__gPhysBase = 0xfffffff007934010,
        .kernelcache__gPhysSize = 0xfffffff007934018,
        .kernelcache__gVirtBase = 0xfffffff0079321e8,
        .kernelcache__perfmon_dev_open = 0xfffffff007eecfc0,
        .kernelcache__perfmon_devices = 0xfffffff00a457500,
        .kernelcache__ptov_table = 0xfffffff0078e7178,
        .kernelcache__vn_kqfilter = 0xfffffff007f39b28,
    },
    // iOS 16.6 - iPhone 12 Pro
    // T1SZ_BOOT must be changed to 25 instead of 17
    {
        .kern_version = "Darwin Kernel Version 22.6.0: Wed Jun 28 20:50:15 PDT 2023; root:xnu-8796.142.1~1/RELEASE_ARM64_T8101",
        .kread_kqueue_workloop_ctl_supported = false,
        .perf_supported = true,
        .proc__p_list__le_prev = 0x0008,
        .proc__p_pid = 0x0060,
        .proc__p_fd__fd_ofiles = 0x00f8,
        .proc__object_size = 0x0730,
        .task__map = 0x0028,
        .thread__thread_id = 0,
        .kernelcache__cdevsw = 0xfffffff00a4a5288,
        .kernelcache__gPhysBase = 0xfffffff0079303b8,
        .kernelcache__gPhysSize = 0xfffffff0079303c0,
        .kernelcache__gVirtBase = 0xfffffff00792e570,
        .kernelcache__perfmon_dev_open = 0xfffffff007ef4278,
        .kernelcache__perfmon_devices = 0xfffffff00a4e5320,
        .kernelcache__ptov_table = 0xfffffff0078e38f0,
        .kernelcache__vn_kqfilter = 0xfffffff007f42f40,
    },
    //17.0b1 12 mini
        {
            .kern_version = "Darwin Kernel Version 23.0.0: Tue May 23 00:20:32 PDT 2023; root:xnu-10002.0.40.502.3~1/RELEASE_ARM64_T8101",
            .kread_kqueue_workloop_ctl_supported = false,
            .perf_supported = true,
            .proc__p_list__le_prev = 0x0008,
            .proc__p_pid = 0x0060,
            .proc__p_fd__fd_ofiles = 0x00f8,
            .proc__object_size = 0x0730,
            .task__map = 0x0028,
            .thread__thread_id = 0,
            .kernelcache__cdevsw = 0xFFFFFFF00A885868,
            .kernelcache__gPhysBase = 0xFFFFFFF007A09058,
            .kernelcache__gPhysSize = 0xFFFFFFF007A09060,
            .kernelcache__gVirtBase = 0xFFFFFFF007A07218,
            .kernelcache__perfmon_dev_open = 0xFFFFFFF00802CFD4,
            .kernelcache__perfmon_devices = 0xFFFFFFF00A8C4E90,
            .kernelcache__ptov_table = 0xFFFFFFF0079BAD18,
            .kernelcache__vn_kqfilter = 0xFFFFFFF00808003C,
        },
    //17.0b2 Xs
        {
            .kern_version = "Darwin Kernel Version 23.0.0: Wed Jun 14 21:10:49 PDT 2023; root:xnu-10002.0.116.502.4~2/RELEASE_ARM64_T8020",
            .kread_kqueue_workloop_ctl_supported = false,
            .perf_supported = true,
            .proc__p_list__le_prev = 0x0008,
            .proc__p_pid = 0x0060,
            .proc__p_fd__fd_ofiles = 0x00f8,
            .proc__object_size = 0x0730,
            .task__map = 0x0028,
            .thread__thread_id = 0,
            .kernelcache__cdevsw = 0xFFFFFFF00A0B1980,
            .kernelcache__gPhysBase = 0xFFFFFFF0078B5750,
            .kernelcache__gPhysSize = 0xFFFFFFF0078B5758,
            .kernelcache__gVirtBase = 0xFFFFFFF0078B3910,
            .kernelcache__perfmon_dev_open = 0xFFFFFFF007E4ACD0,
            .kernelcache__perfmon_devices = 0xFFFFFFF00A0F0E70,
            .kernelcache__ptov_table = 0xFFFFFFF007866CF0,
            .kernelcache__vn_kqfilter = 0xFFFFFFF007E9DDF8,
        },
};

#endif /* dynamic_info_h */
