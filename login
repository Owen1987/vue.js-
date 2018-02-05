1。登录验证为原生验证   2.通过验证器来验证的 3.带有token的令牌验证
1.login.vue
<template>
	<div class="login" >
		
		 <div class="loginDiv">
		 	 <h1 class="loginH">系统登录页面</h1>
		 	<el-card class="box-card" style="background-color: #f3f3f3;">
		 	     
				 <el-form ref="formLogin" :model="formLogin" >
								  <el-form-item >
								    <el-input placeholder="请输入账号" v-model="formLogin.userName" @blur="inputBlur('userName',formLogin.userName)"><template slot="prepend"><!--<i slot="suffix" class="el-input__icon el-icon-date"></i>-->账号</template></el-input>
								    <p>{{formLogin.userError}}</p>
								  </el-form-item>
								  <el-form-item >
								    <el-input  placeholder="请输入密码"v-model="formLogin.password" @blur="inputBlur('password',formLogin.password)" type="password"><template slot="prepend" >密码</template></el-input>
								     <p>{{formLogin.passwordError}}</p>
								  </el-form-item>
								  <el-checkbox v-model="checked" checked class="remember">记住密码</el-checkbox>
								  <el-form-item>
								    <el-button type="primary" @click.native.prevent="submitLogin('formLogin')" style="width:100%" :disabled="formLogin.beDisabled">登  录</el-button>
								    
								  </el-form-item>
			       </el-form>
	       
	        </el-card>		
		 	</div> 
		 	
	</div>
</template>

<script>
	export default{
		name:'loginSys',
		data(){
			return{
				formLogin:{
					userName:'',
					userError:'',
					password:'',
					passwordError:'',
					beDisabled:true,//使用时改true，调试不进入接口时，使用false
				},
				
	
			}
		},
		methods:{
			resetFormLogin(){
				this.formLogin.userName='',
				this.formLogin.userError='',
				this.formLogin.password='',
				this.formLogin.passwordError=''
			},
			
			inputBlur(errorType,inputContent){
				if(errorType=='userName'){
					if(inputContent==''){
						this.formLogin.userError='用户名不能为空';
					}else{
						this.formLogin.userError='';
					}
				}else if(errorType=='password'){
					if(inputContent==''){
						this.formLogin.passwordError='密码不能为空';
					}else{
						this.formLogin.passwordError='';
					}
					
				}
				if(this.formLogin.userName!=''&&this.formLogin.password!=''){
					this.formLogin.beDisabled=false;
				}else{
					this.formLogin.beDisabled=true;
				}
			},
			submitLogin(){//跳转到主页
				let  that=this;
				let config={
			  headers:{
				  'Content-Type': 'application/json'
			 }
		   };
				that.axios.post('/users/loginUsers',
			    {//发送登录信息到登录接口
			      params:{
			      	userName:that.formLogin.userName,
			      	password:that.formLogin.password,
			      }
			    }
				).then((res)=>{}).catch((error)=>{console.log(error)})
				
				
				that.$router.push("/HelloWorld");//跳转到主页
			},
		
		}
	}
</script>

<style scopeed>
	.loginDiv{width:480px;margin:10% auto;}
	.loginDiv .loginH{text-align: center;margin-bottom:20px;}
	
	 html,body{
        margin: 0;
        padding: 0;
        position: relative;
    }
   
    .loginDiv p{
        color: red;
        text-align: left;
    }
    .remember {
      margin: 0px 0px 25px 0px;
    }
    
    
    
    2.使用验证器登录
    <template>
	<div class="login" >
		
		 <div class="loginDiv">
		 	 <h1 class="loginH">系统登录页面</h1>
		 	<el-card class="box-card" style="background-color: #f3f3f3;">
       <el-form ref="formLogin" :model="formLogin" :rules="rulesLogin" >
			       <el-form-item prop="userName">
					      <el-input type="text" v-model="formLogin.userName" auto-complete="off" placeholder="请输入账号"></el-input>
					 </el-form-item>
					 <el-form-item prop="password">
					      <el-input type="password" v-model="formLogin.password" auto-complete="off" placeholder="请输入密码"></el-input>
					  </el-form-item>
					    <el-checkbox v-model="checked" checked class="remember">记住密码</el-checkbox>
					 <el-form-item style="width:100%;">
					      <el-button type="primary" style="width:100%;" @click.native.prevent="submitLogin('formLogin')" :loading="logining">登录</el-button>
					      <!--<el-button @click.native.prevent="handleReset2">重置</el-button>-->
					</el-form-item>
	             </el-form>
	        </el-card>		
		</div> 
		 	
	</div>
</template>
    <script>
    export default{
		name:'loginSys',
		data(){
    
      const validateUserName = (rule, value, callback) => {
          if (value.length < 6) {
            //export function isWscnEmail(str) {
            //const reg = /^[a-z0-9](?:[-_.+]?[a-z0-9]+)*@wz\.com$/i;
            //return reg.test(str.trim());
            //}
            callback(new Error('用户名长度不能＜5位'));
          } else {
            callback();
          }
        };
        const validatePassWord = (rule, value, callback) => {
          if (value.length < 6) {
            callback(new Error('密码不能小于6位'));
          } else {
            callback();
          }
        };
    
			return{
				 logining: false,
				 checked:true,
				formLogin:{
					userName:'admin',
					password:'123456',
					},
					rulesLogin:{
						userName:[
						{required:true,message:'请输入账号',trigger:'blur',validator: validateUserName}
						],
						password:[
						{required: true, message: '请输入密码', trigger: 'blur',validator: validatePassWord}
						]
					}
			}
		},
		methods:{
			submitLogin(formLogin){
					  var that=this;
					  that.$refs.formLogin.validate((valid)=>{
					  	if(valid){
					  		that.logining=false;//调试用，正式去掉
					  		that.$router.push({ path:"/HelloWorld" });//调试用，正式去掉
					  		that.logining=true;
					  		var loginParams = { username: that.formLogin.userName, password: that.formLogin.password };
					  		that.axios.post('/users/loginUsers',loginParams).then((res)=>{
					  			that.logining=false;
					  			let{msg,code,user}=res;
						  		if(code!==200){
						  			that.$message({
						  				message:msg,
						  				type:'error'
						  			});
					  			}else {
		               			 sessionStorage.setItem('user', JSON.stringify(user));//记住用户信息
		               			 that.$router.push({ path:"/HelloWorld" });//跳转到主页
		              			}
					  		
					  			}).catch((error)=>{console.log(error)})
						
						
						}else{
						 	console.log('error submit!!');
		               		return false;
					}
					});
			  	
			  	},
			  	
			  },
		
		
		
	}
	
</script>

<style scopeed>
	.loginDiv{width:480px;margin:10% auto;}
	.loginDiv .loginH{text-align: center;margin-bottom:20px;}
	
	 html,body{
        margin: 0;
        padding: 0;
        position: relative;
    }
   
    .loginDiv p{
        color: red;
        text-align: left;
    }
    .remember {
      margin: 0px 0px 25px 0px;
    }
</style>


