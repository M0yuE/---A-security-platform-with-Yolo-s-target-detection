export default {
    login: '/sys/login',
    captcha: '/captcha.jpg',
    getUserInfo: '/sys/user/info',
    updatePassword: '/sys/user/password',
    user: {
        list: '/sys/user/list',
        saveOrUpdate: '/sys/user/saveOrUpdate',
        isNotExists: '/sys/user/isNotExists',
        deleteBatch: '/sys/user/delete'
    },
    role: {
        list: '/sys/role/list',//角色列表包含菜单（权限）
        listRole: '/sys/role/select',//角色列表不包含菜单
        saveOrUpdate: '/sys/role/saveOrUpdate',
        deleteBatch: '/sys/role/delete',
    },
    menu: {
        list: '/sys/menu/list',
        saveOrUpdate: '/sys/menu/saveOrUpdate',
        deleteBatch: '/sys/menu/delete'
    },
    config: {
        list: 'sys/config/list',
        saveOrUpdate: '/sys/config/saveOrUpdate',
        deleteBatch: '/sys/config/delete'
    },
    schedule: {
        list: '/sys/schedule/list',
        saveSchedule: '/sys/schedule/save',
        updateSchedule: '/sys/schedule/update',
        deleteBatch: '/sys/schedule/delete',
        pause: '/sys/schedule/pause',
        resume: '/sys/schedule/resume',
        runOnce: '/sys/schedule/run',
    },
    scheduleLog: {
        list: '/sys/scheduleLog/list'
    },
    dict: {
        list: '/sys/dict/list',
        save: '/sys/dict/save',
        update: '/sys/dict/update',
        deleteBatch: '/sys/dict/delete',
    },
    sql: {
        html: '/api/druid/sql.html'
    },
    log: {
        list: '/sys/log/list'
    },
    connect: {
        list: '/sec/connect/list',
        listAll: '/sec/connect/listAll',
        saveOrUpdate: '/sec/connect/saveOrUpdate',
        delete: '/sec/connect/delete',
    },
    equipment: {
        modularList: '/sec/equipment/modularList',
        modularSaveOrUpdate: '/sec/equipment/modularSaveOrUpdate',
        modularDelete: '/sec/equipment/modularDelete',
        equipmentList: '/sec/equipment/equipmentList',
        equipmentSaveOrUpdate: '/sec/equipment/equipmentSaveOrUpdate',
        equipmentDelete: '/sec/equipment/equipmentDelete',
        instructList: '/sec/equipment/instructList',
        instructSaveOrUpdate: '/sec/equipment/instructSaveOrUpdate',
        instructDelete: '/sec/equipment/instructDelete',
        dataList: '/sec/equipment/dataList',
        dataSaveOrUpdate: '/sec/equipment/dataSaveOrUpdate',
        dataDelete: '/sec/equipment/dataDelete',
        parseData: '/sec/equipment/parseData',
        getDataListByInstructId:'/sec/equipment/getDataListByInstructId',
        sendInstruct: '/sec/equipment/sendInstruct',
    },
    realTimeData:{
        list:'/sec/realTimeData/list',
        modularsAndEquipments:'/sec/realTimeData/modularsAndEquipments',
    },
    warnMsg:{
        list:'/sec/warnMsg/list',
        read:'/sec/warnMsg/read',
        warnCount:'/sec/warnMsg/warnCount',
    },
    socket:{
        sysWebsocket: '/api/socket/sysWebsocket',
        dataWebsocket: '/api/socket/dataWebsocket',
    },
    video: {
        list: '/sec/video/list',
        saveOrUpdate: '/sec/video/saveOrUpdate',
        deleteBatch: '/sec/video/delete'
    },
    data:{
        showData:'/showData/timeDifference',
        NodeData:'/showData/NodeData',
        uniDataWarnMsg:'/sec/warnMsg/uniDataWarnMsg',
    },
}
