package com.antd.modules.sys.service;

import com.antd.common.utils.Constant;
import com.antd.modules.sys.dao.SysMenuDao;
import com.antd.modules.sys.dao.SysUserDao;
import com.antd.modules.sys.entity.SysMenuEntity;
import com.antd.modules.sys.entity.SysUserEntity;
import com.antd.modules.sys.shiro.JwtAuthFilter;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
public class UserPermsService {
    private final Logger logger = LoggerFactory.getLogger(JwtAuthFilter.class);
    @Resource
    private RedisTemplate redisTemplate;
    @Autowired
    private SysUserDao sysUserDao;
    @Autowired
    private SysMenuDao sysMenuDao;
    @Async("asyncServiceExecutor")
    public void updateByUserName(String username){
        String key = "user:" + username;
        Object cacheUser = redisTemplate.opsForValue().get(key);
        if(cacheUser != null){//更新缓存
            SysUserEntity user = sysUserDao.selectOne(new QueryWrapper<SysUserEntity>().eq("username", username));
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
            Long expire = redisTemplate.getExpire(key,TimeUnit.MINUTES);
            redisTemplate.opsForValue().set(key,user,expire, TimeUnit.MINUTES);
            logger.info("通过用户名更新缓存完成"+username);
        }
    }
    @Async("asyncServiceExecutor")
    public void deleteCacheUserByIdList(Long[] userIds){
        for(Long id : userIds){
            SysUserEntity user = sysUserDao.selectOne(new QueryWrapper<SysUserEntity>().eq("user_id", id));
            redisTemplate.delete("user:"+user.getUsername());
            logger.info("通过用户名删除缓存完成"+user.getUsername());
        }
    }
    @Async("asyncServiceExecutor")
    public void updateAllCacheUser(){
        Set<String> keys = redisTemplate.keys("user:*");
        for(String key : keys){
            String[] split = key.split(":");
            if(split.length > 1){
                String username = split[1];
                SysUserEntity user = sysUserDao.selectOne(new QueryWrapper<SysUserEntity>().eq("username", username));
                if(user != null){
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
                    Long expire = redisTemplate.getExpire(key,TimeUnit.MINUTES);
                    redisTemplate.opsForValue().set(key,user,expire, TimeUnit.MINUTES);
                    logger.info("通过更新全部用户缓存"+user.getUsername());
                    keys.remove(key);
                }
            }
        }
        for(String key : keys){
            redisTemplate.delete(key);
        }
    }
}
