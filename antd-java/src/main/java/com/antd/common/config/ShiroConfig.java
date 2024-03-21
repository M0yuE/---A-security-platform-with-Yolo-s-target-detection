package com.antd.common.config;

import com.antd.modules.sys.shiro.JWTShiroRealm;
import com.antd.modules.sys.shiro.JwtAuthFilter;
import org.apache.shiro.mgt.DefaultSessionStorageEvaluator;
import org.apache.shiro.mgt.DefaultSubjectDAO;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.mgt.SessionStorageEvaluator;
import org.apache.shiro.spring.LifecycleBeanPostProcessor;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.spring.web.config.DefaultShiroFilterChainDefinition;
import org.apache.shiro.spring.web.config.ShiroFilterChainDefinition;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.apache.shiro.web.mgt.DefaultWebSessionStorageEvaluator;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import java.util.Map;
@Configuration
public class ShiroConfig {

    @Bean("securityManager")
    public SecurityManager securityManager(JWTShiroRealm jwtShiroRealm) {
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        securityManager.setRealm(jwtShiroRealm);
        // 关闭session存储，禁用Session作为存储策略的实现，但它没有完全地禁用Session所以需要配合SubjectFactory中的context.setSessionCreationEnabled(false)
        ((DefaultSessionStorageEvaluator) ((DefaultSubjectDAO)securityManager.getSubjectDAO()).getSessionStorageEvaluator()).setSessionStorageEnabled(false);
        return securityManager;
    }
    @Bean("jwtRealm")
    public JWTShiroRealm jwtShiroRealm() {
        JWTShiroRealm myShiroRealm = new JWTShiroRealm();
        return myShiroRealm;
    }
    @Bean
    public FilterRegistrationBean<Filter> filterRegistrationBean(SecurityManager securityManager) throws Exception{
        FilterRegistrationBean<Filter> filterRegistration = new FilterRegistrationBean<Filter>();
        filterRegistration.setFilter((Filter)shiroFilter(securityManager).getObject());
        filterRegistration.addInitParameter("targetFilterLifecycle", "true");
        filterRegistration.setAsyncSupported(true);
        filterRegistration.setEnabled(true);
        filterRegistration.setDispatcherTypes(DispatcherType.REQUEST, DispatcherType.ASYNC);
        return filterRegistration;
    }
    @Bean
    protected SessionStorageEvaluator sessionStorageEvaluator(){
        DefaultWebSessionStorageEvaluator sessionStorageEvaluator = new DefaultWebSessionStorageEvaluator();
        sessionStorageEvaluator.setSessionStorageEnabled(false);
        return sessionStorageEvaluator;
    }
    @Bean("shiroFilter")
    public ShiroFilterFactoryBean shiroFilter(SecurityManager securityManager) {
        ShiroFilterFactoryBean shiroFilter = new ShiroFilterFactoryBean();
        shiroFilter.setSecurityManager(securityManager);
        Map<String,Filter> filters = shiroFilter.getFilters();
        filters.put("authcToken", createAuthFilter());
        shiroFilter.setFilters(filters);
        shiroFilter.setFilterChainDefinitionMap(shiroFilterChainDefinition().getFilterChainMap());
        return shiroFilter;
    }
    @Bean
    protected ShiroFilterChainDefinition shiroFilterChainDefinition() {
        DefaultShiroFilterChainDefinition filterMap = new DefaultShiroFilterChainDefinition();
        filterMap.addPathDefinition("/swagger/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/v2/api-docs", "noSessionCreation,anon");
        filterMap.addPathDefinition("/swagger-ui.html", "noSessionCreation,anon");
        filterMap.addPathDefinition("/webjars/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/swagger-resources/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/statics/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/login.html", "noSessionCreation,anon");
        filterMap.addPathDefinition("/sys/login**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/favicon.ico", "noSessionCreation,anon");
        filterMap.addPathDefinition("/captcha.jpg", "noSessionCreation,anon");
        filterMap.addPathDefinition("/druid/js/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/druid/css/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/shop/upload/getImage/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/druid/*.json", "noSessionCreation,anon");
        filterMap.addPathDefinition("/druid/*.html", "noSessionCreation,anon");
        filterMap.addPathDefinition("/socket/**", "noSessionCreation,anon");
        filterMap.addPathDefinition("/**", "noSessionCreation,authcToken");

        return filterMap;
    }
    protected JwtAuthFilter createAuthFilter(){
        return new JwtAuthFilter();
    }
    @Bean("lifecycleBeanPostProcessor")
    public LifecycleBeanPostProcessor lifecycleBeanPostProcessor() {
        return new LifecycleBeanPostProcessor();
    }

    @Bean
    public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
        AuthorizationAttributeSourceAdvisor advisor = new AuthorizationAttributeSourceAdvisor();
        advisor.setSecurityManager(securityManager);
        return advisor;
    }
}
