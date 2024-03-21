package com.antd.modules.sys.controller;


import com.alibaba.druid.util.StringUtils;
import com.antd.common.utils.Constant;
import com.antd.common.utils.JwtUtils;
import com.antd.common.utils.R;
import com.antd.modules.sys.dao.SysMenuDao;
import com.antd.modules.sys.dao.SysUserDao;
import com.antd.modules.sys.entity.SysMenuEntity;
import com.antd.modules.sys.entity.SysUserEntity;
import com.antd.modules.sys.shiro.ShiroUtils;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import com.google.code.kaptcha.Producer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Controller
public class SysLoginController {
	@Autowired
	private Producer producer;
	@Resource
	private RedisTemplate redisTemplate;
	@Autowired
	private SysUserDao sysUserDao;
	@Autowired
	private SysMenuDao sysMenuDao;
	@RequestMapping("captcha.jpg")
	public void captcha(HttpServletResponse response, HttpServletRequest request,String token)throws IOException {
        response.setHeader("Cache-Control", "no-store, no-cache");
        response.setContentType("image/jpeg");

        //生成文字验证码
        String text = producer.createText();
        //生成图片验证码
        BufferedImage image = producer.createImage(text);
		String key = request.getHeader(Constant.TOKEN);
		boolean newKey = false;
		if(StringUtils.isEmpty(key) && StringUtils.isEmpty(token)){
			newKey = true;
		}else{
			Object keyObj = redisTemplate.opsForValue().get("validate:" + key);
			if(keyObj == null){
				newKey = true;
			}
		}
		if(newKey){
			key = IdWorker.getIdStr();
			response.setHeader("flush-token","true");
			response.setHeader("token",key);
		}
		redisTemplate.opsForValue().set("validate:"+key,text,15, TimeUnit.MINUTES);
        ServletOutputStream out = response.getOutputStream();
        ImageIO.write(image, "jpg", out);
	}
	
	/**
	 * 登录
	 */
	@ResponseBody
	@RequestMapping(value = "/sys/login", method = RequestMethod.POST)
	public R login(String username, String password, String captcha,HttpServletRequest request,HttpServletResponse response) {
		String key = request.getHeader(Constant.TOKEN);
		if(StringUtils.isEmpty(key)){
			return R.error("token不存在");
		}
		Object keyObj = redisTemplate.opsForValue().get("validate:"+key);
		if(keyObj == null || StringUtils.isEmpty(keyObj.toString())){
			return R.error("验证码token过期");
		}
		String kaptcha = keyObj.toString();
		if(!captcha.equalsIgnoreCase(kaptcha)){
			return R.error("验证码不正确");
		}
		return validateUser(username,password,response);
	}
	private R validateUser(String username,String password,HttpServletResponse response){
		SysUserEntity user = sysUserDao.selectOne(new QueryWrapper<SysUserEntity>().eq("username", username));
		if(user == null){
			return R.error("用户名不正确");
		}
		password = ShiroUtils.sha256(password, user.getSalt());
		if(!user.getPassword().equals(password)){
			return R.error("密码不正确");
		}
		if(user.getStatus() == 0){
			return R.error("账号已被锁定,请联系管理员");
		}
		//创建jwt token返回
		response.setHeader("flush-token","true");
		String token = JwtUtils.generateToken(user);
		response.setHeader("token",token);
		//将用户信息放进redis中
		Long userId = user.getUserId();
		List<String> permsList;
		//系统管理员，拥有最高权限
		if(userId == Constant.SUPER_ADMIN){
			List<SysMenuEntity> menuList = sysMenuDao.selectList(null);
			permsList = new ArrayList<>(menuList.size());
			for(SysMenuEntity menu : menuList){
				permsList.add(menu.getPerms());
			}
		}else{
			permsList = sysUserDao.queryAllPerms(userId);
		}
		//用户权限列表
		Set<String> permsSet = new HashSet<>();
		for(String perms : permsList){
			if(org.apache.commons.lang.StringUtils.isBlank(perms)){
				continue;
			}
			permsSet.addAll(Arrays.asList(perms.trim().split(",")));
		}
		user.setPermsList(permsSet);
		redisTemplate.opsForValue().set("user:"+user.getUsername(),user,12,TimeUnit.HOURS);
		return R.ok("登陆成功");
	}
	/**
	 * 登录
	 */
	@ResponseBody
	@RequestMapping(value = "/sys/loginByUni", method = RequestMethod.POST)
	public R phoneLogin(String username, String password,HttpServletRequest request,HttpServletResponse response) {
		return validateUser(username,password,response);
	}
	/**
	 * 退出
	 */
	/*@RequestMapping(value = "/sys/logout", method = RequestMethod.GET)
	@ResponseBody
	public R logout() {
		ShiroUtils.logout();
		return R.ok();
	}*/
	
}
