const api = {
	login: '/sys/loginByUni',
	getUserInfo: '/sys/user/info',
	wapInfo:'/wap/info',
	realData:'/sec/realTimeData/uniappRealData',
	controlData:'/sec/equipment/uniControllerData',
	sendInstruct:'/sec/equipment/uniSendInstruct',
	warnMsg:'/sec/warnMsg/uniDataWarnMsg',
	warnMsgRead:'/sec/warnMsg/uniReadWarnMsg',
	warnMsgDelete:'/sec/warnMsg/uniDeleteWarnMsg',
}
export default api