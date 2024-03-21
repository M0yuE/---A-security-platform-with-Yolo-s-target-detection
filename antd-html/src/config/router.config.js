// eslint-disable-next-line
import {UserLayout, BasicLayout, RouteView, BlankLayout, PageView} from '@/layouts'
import {bxAnaalyse} from '@/core/icons'

export const asyncRouterMap = [

    {
        path: '/',
        name: 'index',
        component: BasicLayout,
        meta: {title: '首页'},
        redirect: '/sys',
        children: [
            {
                path: '/sys',
                name: 'sys',
                component: PageView,
                meta: {title: '系统管理', icon: 'setting', permission: 'sys'},
                redirect: '/sys/user',
                children: [
                    {
                        path: '/sys/user',
                        name: 'User',
                        component: () => import('@/components/sys/User'),
                        meta: {permission: 'sys.user', title: '用户管理', icon: 'user'}
                    },
                    {
                        path: '/sys/role',
                        name: 'Role',
                        component: () => import('@/components/sys/Role'),
                        meta: {permission: 'sys.role', title: '角色管理', icon: 'team'}
                    },
                    {
                        path: '/sys/menu',
                        name: 'Menu',
                        component: () => import('@/components/sys/Menu'),
                        meta: {permission: 'sys.menu', title: '菜单管理', icon: 'bars'}
                    },
                    {
                        path: '/sys/config',
                        name: 'Config',
                        component: () => import('@/components/sys/Config'),
                        meta: {permission: 'sys.config', title: '参数管理', icon: 'project'}
                    },
                    {
                        path: '/sys/sql',
                        name: 'Sql',
                        component: () => import('@/components/sys/Sql'),
                        meta: {permission: 'sys.sql', title: 'sql监控', icon: 'eye'}
                    },
                    {
                        path: '/schedule/job',
                        name: 'job',
                        component: () => import('@/components/sys/Job'),
                        meta: {title: '定时任务', permission: ['sys.schedule'], icon: 'hourglass'}
                    },
                    {
                        path: '/schedule/log',
                        name: 'log',
                        hidden: true,
                        component: () => import('@/components/sys/ScheduleLog'),
                        meta: {title: '定时任务日志', permission: ['sys.schedule.log']}
                    },
                    {
                        path: '/sys/dict',
                        name: 'dict',
                        component: () => import('@/components/sys/Dict'),
                        meta: {title: '字典管理', permission: ['sys.dict'], icon: 'appstore'}
                    },
                    {
                        path: '/sys/log',
                        name: 'sysLog',
                        component: () => import('@/components/sys/Log'),
                        meta: {title: '系统日志', permission: ['sys.log'], icon: 'history'}
                    }
                ]
            },
            {
                path: '/connectEquipment',
                name: 'connectEquipment',
                component: PageView,
                meta: {title: '连接/设备管理', icon: 'setting', permission: 'connectEquipment'},
                redirect: '/connectEquipment/connect',
                children: [
                    {
                        path: '/connectEquipment/connect',
                        name: 'Connect',
                        component: () => import('@/components/connectEquipment/Connect'),
                        meta: {permission: 'connectEquipment.connect', title: '连接管理', icon: 'swap'}
                    },
                    {
                        path: '/connectEquipment/equipment',
                        name: 'Equipment',
                        component: () => import('@/components/connectEquipment/Equipment'),
                        meta: {permission: 'connectEquipment.equipment', title: '设备管理', icon: 'alert'},
                    },
                ]
            },
            {
                path: '/secData',
                name: 'secData',
                component: PageView,
                meta: {title: '数据管理', icon: 'setting', permission: 'secData'},
                redirect: '/secData/realTimeData',
                children: [
                    {
                        path: '/secData/realTimeData',
                        name: 'RealTimeData',
                        component: () => import('@/components/secData/RealTimeData'),
                        meta: {permission: 'secData.realTimeData', title: '实时数据', icon: 'database'}
                    },
                    {
                        path: '/secData/warnMsg',
                        name: 'WarnMsg',
                        component: () => import('@/components/secData/WarnMsg'),
                        meta: {permission: 'secData.realTimeData', title: '警告消息', icon: 'message'}
                    },
                ]
            },
            // {
            //     path: '/ShowData/index',
            //             name: 'RealShowData',
            //             component: () => import('@/components/ShowData/index'),
            //             meta: {permission: 'secData.realTimeData', title: '展示数据', icon: 'database'}
            // },
            {
                path: '/ShowData',
                name: 'ShowData',
                component: PageView,
                meta: {title: '数据展示', icon: 'setting', permission: 'secData'},
                redirect: '/ShowData/index',
                children: [
                    {
                        path: '/ShowData/index',
                        name: 'RealShowData',
                        component: () => import('@/components/ShowData/showData'),
                        meta: {permission: 'secData.realTimeData', title: '展示数据', icon: 'database'}
                    },
                ]
            },



            {
                path: '/secVideo',
                name: 'secVideo',
                component: PageView,
                meta: {title: '视频管理', icon: 'setting', permission: 'secVideo'},
                redirect: '/secVideo/video',
                children: [
                    {
                        path: '/secVideo/video',
                        name: 'Video',
                        component: () => import('@/components/secVideo/Video'),
                        meta: {permission: 'secVideo.video', title: '实时视频', icon: 'play-square'}
                    },
                ]
            },
            // Exception
            {
                path: '/exception',
                name: 'exception',
                component: RouteView,
                redirect: '/exception/403',
                meta: {title: '异常页', icon: 'warning', permission: ['exception']},
                children: [
                    {
                        path: '/exception/403',
                        name: 'Exception403',
                        component: () => import(/* webpackChunkName: "fail" */ '@/views/exception/403'),
                        meta: {title: '403', permission: ['exception']}
                    },
                    {
                        path: '/exception/404',
                        name: 'Exception404',
                        component: () => import(/* webpackChunkName: "fail" */ '@/views/exception/404'),
                        meta: {title: '404', permission: ['exception']}
                    },
                    {
                        path: '/exception/500',
                        name: 'Exception500',
                        component: () => import(/* webpackChunkName: "fail" */ '@/views/exception/500'),
                        meta: {title: '500', permission: ['exception']}
                    }
                ]
            },
        ]
    },
    {
        path: '*', redirect: '/404', hidden: true
    }
]

/**
 * 基础路由
 * @type { *[] }
 */
export const constantRouterMap = [
    {
        path: '/user',
        component: UserLayout,
        redirect: '/user/login',
        hidden: true,
        children: [
            {
                path: 'login',
                name: 'login',
                component: () => import(/* webpackChunkName: "user" */ '@/views/user/Login')
            },
        ]
    },
    {
        path: '/404',
        component: () => import(/* webpackChunkName: "fail" */ '@/views/exception/404')
    }

]
